data "openstack_images_image_v2" "vm_image" {
  name = "${var.image}"
}

data "openstack_images_image_v2" "gfs_image" {
  name = "${var.image_gfs == "" ? var.image : var.image_gfs}"
}

resource "openstack_compute_keypair_v2" "k8s" {
  name       = "kubernetes-${var.cluster_name}"
  public_key = "${chomp(file(var.public_key_path))}"
}

resource "openstack_networking_secgroup_v2" "k8s_master" {
  name                 = "${var.cluster_name}-k8s-master"
  description          = "${var.cluster_name} - Kubernetes Master"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "k8s_master" {
  count             = "${length(var.master_allowed_remote_ips)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "6443"
  port_range_max    = "6443"
  remote_ip_prefix  = "${var.master_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s_master.id}"
}

resource "openstack_networking_secgroup_v2" "bastion" {
  name                 = "${var.cluster_name}-bastion"
  count                = "${var.number_of_bastions}"
  description          = "${var.cluster_name} - Bastion Server"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "bastion" {
  count             = "${var.number_of_bastions != 0 ? length(var.bastion_allowed_remote_ips) : 0}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
  remote_ip_prefix  = "${var.bastion_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.bastion[count.index].id}"
}

resource "openstack_networking_secgroup_v2" "k8s" {
  name                 = "${var.cluster_name}-k8s"
  description          = "${var.cluster_name} - Kubernetes"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "k8s" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = "${openstack_networking_secgroup_v2.k8s.id}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_allowed_remote_ips" {
  count             = "${length(var.k8s_allowed_remote_ips)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
  remote_ip_prefix  = "${var.k8s_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}

resource "openstack_networking_secgroup_rule_v2" "egress" {
  count             = "${length(var.k8s_allowed_egress_ips)}"
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "${var.k8s_allowed_egress_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}

resource "openstack_networking_secgroup_v2" "worker" {
  name                 = "${var.cluster_name}-k8s-worker"
  description          = "${var.cluster_name} - Kubernetes worker nodes"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "worker" {
  count             = "${length(var.worker_allowed_ports)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "${lookup(var.worker_allowed_ports[count.index], "protocol", "tcp")}"
  port_range_min    = "${lookup(var.worker_allowed_ports[count.index], "port_range_min")}"
  port_range_max    = "${lookup(var.worker_allowed_ports[count.index], "port_range_max")}"
  remote_ip_prefix  = "${lookup(var.worker_allowed_ports[count.index], "remote_ip_prefix", "0.0.0.0/0")}"
  security_group_id = "${openstack_networking_secgroup_v2.worker.id}"
}

resource "openstack_compute_instance_v2" "bastion" {
  name       = "${var.cluster_name}-bastion-${count.index+1}"
  count      = "${var.bastion_root_volume_size_in_gb == 0 ? var.number_of_bastions : 0}"
  image_name = "${var.image}"
  flavor_id  = "${var.flavor_bastion}"
  key_pair   = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}",
    "${element(openstack_networking_secgroup_v2.bastion.*.name, count.index)}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "bastion"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${var.bastion_fips[0]}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_compute_instance_v2" "bastion_custom_volume_size" {
  name       = "${var.cluster_name}-bastion-${count.index+1}"
  count      = "${var.bastion_root_volume_size_in_gb > 0 ? var.number_of_bastions : 0}"
  image_name = "${var.image}"
  flavor_id  = "${var.flavor_bastion}"
  key_pair   = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.bastion_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}",
    "${element(openstack_networking_secgroup_v2.bastion.*.name, count.index)}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "bastion"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${var.bastion_fips[0]}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_compute_instance_v2" "k8s_master" {
  name              = "${var.cluster_name}-k8s-master-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb == 0 ? var.number_of_k8s_masters : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s_master.name}",
    "${openstack_networking_secgroup_v2.k8s.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "etcd,kube-master,${var.supplementary_master_groups},k8s-cluster,vault"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${element( concat(var.bastion_fips, var.k8s_master_fips), 0)}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_compute_instance_v2" "k8s_master_custom_volume_size" {
  name              = "${var.cluster_name}-k8s-master-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb > 0 ? var.number_of_k8s_masters : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.master_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s_master.name}",
    "${openstack_networking_secgroup_v2.k8s.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "etcd,kube-master,${var.supplementary_master_groups},k8s-cluster,vault"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${element( concat(var.bastion_fips, var.k8s_master_fips), 0)}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_compute_instance_v2" "k8s_master_no_etcd" {
  name              = "${var.cluster_name}-k8s-master-ne-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb == 0 ? var.number_of_k8s_masters_no_etcd : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s_master.name}",
    "${openstack_networking_secgroup_v2.k8s.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-master,${var.supplementary_master_groups},k8s-cluster,vault"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${element( concat(var.bastion_fips, var.k8s_master_fips), 0)}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_compute_instance_v2" "k8s_master_no_etcd_custom_volume_size" {
  name              = "${var.cluster_name}-k8s-master-ne-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb > 0 ? var.number_of_k8s_masters_no_etcd : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.master_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s_master.name}",
    "${openstack_networking_secgroup_v2.k8s.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-master,${var.supplementary_master_groups},k8s-cluster,vault"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${element( concat(var.bastion_fips, var.k8s_master_fips), 0)}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_compute_instance_v2" "etcd" {
  name              = "${var.cluster_name}-etcd-${count.index+1}"
  count             = "${var.etcd_root_volume_size_in_gb == 0 ? var.number_of_etcd : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_etcd}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}"]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "etcd,vault,no-floating"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "etcd_custom_volume_size" {
  name              = "${var.cluster_name}-etcd-${count.index+1}"
  count             = "${var.etcd_root_volume_size_in_gb > 0 ? var.number_of_etcd : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_etcd}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.etcd_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}"]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "etcd,vault,no-floating"
    depends_on       = "${var.network_id}"
  }
}

# calico-rr
variable "subnet_ids" {
  type        = list(string)
  default     = ["d85e2b9e-f9e2-45e5-82d4-8990830cac49","0ba57227-231e-486a-a196-a2ae5c0521c6"]
}
variable "reflectors" {
  type        = list(string)
  default     = ["10.184.42.241", "10.184.46.241"]
}
variable "subnets" {
  type        = list(string)
  default     = ["10.184.42.0", "10.184.46.0"]
}

resource "openstack_networking_secgroup_v2" "rr" {
  name                 = "${var.cluster_name}-rr"
  description          = "${var.cluster_name} - Calico Route Reflector"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "rr" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "179"
  port_range_max    = "179"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.rr.id}"
}

resource "openstack_networking_port_v2" "k8s_calico_rr_no_floating_ip" {
  name           = "${var.cluster_name}-k8s-calico-rr-nf-${count.index+1}"
  count          = length(var.subnet_ids)
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"
  # neutron/policy.json get_port, create_port:fixed_ips:subnet_id y create_port:fixed_ips:ip_address a ""
  fixed_ip {
     subnet_id  = var.subnet_ids[count.index]
     ip_address =  var.reflectors[count.index]
  }

  security_group_ids = ["${openstack_networking_secgroup_v2.k8s.id}",
      "${openstack_networking_secgroup_v2.rr.id}" ]
}

resource "openstack_compute_instance_v2" "k8s_calico_rr_no_floating_ip" {
  name              = "${var.cluster_name}-k8s-calico-rr-nf-${count.index+1}"
  count             = length(var.subnet_ids)
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_calico_rr}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    port = "${element(openstack_networking_port_v2.k8s_calico_rr_no_floating_ip.*.id, count.index)}"
  }

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "calico-rr,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
    cluster_id       = var.subnets[count.index]
    node_taints      = "calico-rr=true:NoSchedule"
  }
}

# master
resource "openstack_networking_port_v2" "k8s_master_no_floating_ip" {
  name           = "${var.cluster_name}-k8s-master-nf-${count.index+1}"
  count          = "${var.number_of_k8s_masters_no_floating_ip}"
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"

  security_group_ids = ["${openstack_networking_secgroup_v2.k8s_master.id}",
    "${openstack_networking_secgroup_v2.k8s.id}",
  ]

  # https://github.com/kubernetes-sigs/kubespray/blob/master/docs/openstack.md
  # sudo -i openstack port set 8127f6d5-86cf-421f-8328-378b07da11eb --allowed-address ip-address=10.233.0.0/18 --allowed-address ip-address=10.233.64.0/18
  allowed_address_pairs {
    ip_address = "${var.kube_service_addresses}"
  }
  allowed_address_pairs {
    ip_address = "${var.kube_pods_subnet}"
  }
}

resource "openstack_compute_instance_v2" "k8s_master_no_floating_ip" {
  name              = "${var.cluster_name}-k8s-master-nf-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb == 0 ? var.number_of_k8s_masters_no_floating_ip : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    port = "${element(openstack_networking_port_v2.k8s_master_no_floating_ip.*.id, count.index)}"
  }

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "etcd,kube-master,${var.supplementary_master_groups},k8s-cluster,vault,no-floating"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "k8s_master_no_floating_ip_custom_volume_size" {
  name              = "${var.cluster_name}-k8s-master-nf-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb > 0 ? var.number_of_k8s_masters_no_floating_ip : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.master_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s_master.name}",
    "${openstack_networking_secgroup_v2.k8s.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "etcd,kube-master,${var.supplementary_master_groups},k8s-cluster,vault,no-floating"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "k8s_master_no_floating_ip_no_etcd" {
  name              = "${var.cluster_name}-k8s-master-ne-nf-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb == 0 ? var.number_of_k8s_masters_no_floating_ip_no_etcd : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s_master.name}",
    "${openstack_networking_secgroup_v2.k8s.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-master,${var.supplementary_master_groups},k8s-cluster,vault,no-floating"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "k8s_master_no_floating_ip_no_etcd_custom_volume_size" {
  name              = "${var.cluster_name}-k8s-master-ne-nf-${count.index+1}"
  count             = "${var.master_root_volume_size_in_gb > 0 ? var.number_of_k8s_masters_no_floating_ip_no_etcd : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_master}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.master_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s_master.name}",
    "${openstack_networking_secgroup_v2.k8s.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-master,${var.supplementary_master_groups},k8s-cluster,vault,no-floating"
    depends_on       = "${var.network_id}"
  }
}

# nodes / workers
resource "openstack_compute_instance_v2" "k8s_node" {
  name              = "${var.cluster_name}-k8s-node-${count.index+1}"
  count             = "${var.node_root_volume_size_in_gb == 0 ? var.number_of_k8s_nodes : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_node}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}",
    "${openstack_networking_secgroup_v2.worker.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${element( concat(var.bastion_fips, var.k8s_node_fips), 0)}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_compute_instance_v2" "k8s_node_custom_volume_size" {
  name              = "${var.cluster_name}-k8s-node-${count.index+1}"
  count             = "${var.node_root_volume_size_in_gb > 0 ? var.number_of_k8s_nodes : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_node}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.node_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}",
    "${openstack_networking_secgroup_v2.worker.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
  }

  provisioner "local-exec" {
    command = "sed s/USER/${var.ssh_user}/ ../../contrib/terraform/openstack/ansible_bastion_template.txt | sed s/BASTION_ADDRESS/${element( concat(var.bastion_fips, var.k8s_node_fips), 0)}/ > group_vars/no-floating.yml"
  }
}

resource "openstack_networking_port_v2" "k8s_node_no_floating_ip" {
  name           = "${var.cluster_name}-k8s-node-nf-${count.index+1}"
  count          = "${var.number_of_k8s_nodes_no_floating_ip}"
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"

  security_group_ids = ["${openstack_networking_secgroup_v2.k8s.id}",
    "${openstack_networking_secgroup_v2.worker.id}",
  ]

  allowed_address_pairs {
    ip_address = "${var.kube_service_addresses}"
  }
  allowed_address_pairs {
    ip_address = "${var.kube_pods_subnet}"
  }
}

resource "openstack_compute_instance_v2" "k8s_node_no_floating_ip" {
  name              = "${var.cluster_name}-k8s-node-nf-${count.index+1}"
  count             = "${var.node_root_volume_size_in_gb == 0 ? var.number_of_k8s_nodes_no_floating_ip : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_node}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    port = "${element(openstack_networking_port_v2.k8s_node_no_floating_ip.*.id, count.index)}"
  }

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "k8s_node_no_floating_ip_custom_volume_size" {
  name              = "${var.cluster_name}-k8s-node-nf-${count.index+1}"
  count             = "${var.node_root_volume_size_in_gb > 0 ? var.number_of_k8s_nodes_no_floating_ip : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_node}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
    source_type           = "image"
    volume_size           = "${var.node_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}",
    "${openstack_networking_secgroup_v2.worker.name}",
  ]

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "bastion" {
  count                 = "${var.bastion_root_volume_size_in_gb == 0 ? var.number_of_bastions : 0}"
  floating_ip           = "${var.bastion_fips[count.index]}"
  instance_id           = "${element(openstack_compute_instance_v2.bastion.*.id, count.index)}"
  wait_until_associated = "${var.wait_for_floatingip}"
}

resource "openstack_compute_floatingip_associate_v2" "bastion_custom_volume_size" {
  count                 = "${var.bastion_root_volume_size_in_gb > 0 ? var.number_of_bastions : 0}"
  floating_ip           = "${var.bastion_fips[count.index]}"
  instance_id           = "${element(openstack_compute_instance_v2.bastion_custom_volume_size.*.id, count.index)}"
  wait_until_associated = "${var.wait_for_floatingip}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s_master" {
  count                 = "${var.master_root_volume_size_in_gb == 0 ? var.number_of_k8s_masters : 0}"
  instance_id           = "${element(openstack_compute_instance_v2.k8s_master.*.id, count.index)}"
  floating_ip           = "${var.k8s_master_fips[count.index]}"
  wait_until_associated = "${var.wait_for_floatingip}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s_master_custom_volume_size" {
  count                 = "${var.master_root_volume_size_in_gb > 0 ? var.number_of_k8s_masters : 0}"
  instance_id           = "${element(openstack_compute_instance_v2.k8s_master_custom_volume_size.*.id, count.index)}"
  floating_ip           = "${var.k8s_master_fips[count.index]}"
  wait_until_associated = "${var.wait_for_floatingip}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s_master_no_etcd" {
  count       = "${var.master_root_volume_size_in_gb == 0 ? var.number_of_k8s_masters_no_etcd : 0}"
  instance_id = "${element(openstack_compute_instance_v2.k8s_master_no_etcd.*.id, count.index)}"
  floating_ip = "${var.k8s_master_no_etcd_fips[count.index]}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s_master_no_etcd_custom_volume_size" {
  count       = "${var.master_root_volume_size_in_gb > 0 ? var.number_of_k8s_masters_no_etcd : 0}"
  instance_id = "${element(openstack_compute_instance_v2.k8s_master_no_etcd_custom_volume_size.*.id, count.index)}"
  floating_ip = "${var.k8s_master_no_etcd_fips[count.index]}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s_node" {
  count                 = "${var.node_root_volume_size_in_gb == 0 ? var.number_of_k8s_nodes : 0}"
  floating_ip           = "${var.k8s_node_fips[count.index]}"
  instance_id           = "${element(openstack_compute_instance_v2.k8s_node.*.id, count.index)}"
  wait_until_associated = "${var.wait_for_floatingip}"
}

resource "openstack_compute_floatingip_associate_v2" "k8s_node_custom_volume_size" {
  count                 = "${var.node_root_volume_size_in_gb > 0 ? var.number_of_k8s_nodes : 0}"
  floating_ip           = "${var.k8s_node_fips[count.index]}"
  instance_id           = "${element(openstack_compute_instance_v2.k8s_node_custom_volume_size.*.id, count.index)}"
  wait_until_associated = "${var.wait_for_floatingip}"
}

resource "openstack_blockstorage_volume_v2" "glusterfs_volume" {
  name        = "${var.cluster_name}-glusterfs_volume-${count.index+1}"
  count       = "${var.gfs_root_volume_size_in_gb == 0 ? var.number_of_gfs_nodes_no_floating_ip : 0}"
  description = "Non-ephemeral volume for GlusterFS"
  size        = "${var.gfs_volume_size_in_gb}"
}

resource "openstack_blockstorage_volume_v2" "glusterfs_volume_custom_volume_size" {
  name        = "${var.cluster_name}-glusterfs_volume-${count.index+1}"
  count       = "${var.gfs_root_volume_size_in_gb > 0 ? var.number_of_gfs_nodes_no_floating_ip : 0}"
  description = "Non-ephemeral volume for GlusterFS"
  size        = "${var.gfs_volume_size_in_gb}"
}

resource "openstack_compute_instance_v2" "glusterfs_node_no_floating_ip" {
  name              = "${var.cluster_name}-gfs-node-nf-${count.index+1}"
  count             = "${var.gfs_root_volume_size_in_gb == 0 ? var.number_of_gfs_nodes_no_floating_ip : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image_gfs}"
  flavor_id         = "${var.flavor_gfs_node}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}"]

  metadata = {
    ssh_user         = "${var.ssh_user_gfs}"
    kubespray_groups = "gfs-cluster,network-storage,no-floating"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_instance_v2" "glusterfs_node_no_floating_ip_custom_volume_size" {
  name              = "${var.cluster_name}-gfs-node-nf-${count.index+1}"
  count             = "${var.gfs_root_volume_size_in_gb > 0 ? var.number_of_gfs_nodes_no_floating_ip : 0}"
  availability_zone = "${element(var.az_list, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_gfs_node}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.gfs_image.id}"
    source_type           = "image"
    volume_size           = "${var.gfs_root_volume_size_in_gb}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = ["${openstack_networking_secgroup_v2.k8s.name}"]

  metadata = {
    ssh_user         = "${var.ssh_user_gfs}"
    kubespray_groups = "gfs-cluster,network-storage,no-floating"
    depends_on       = "${var.network_id}"
  }
}

resource "openstack_compute_volume_attach_v2" "glusterfs_volume" {
  count       = "${var.gfs_root_volume_size_in_gb == 0 ? var.number_of_gfs_nodes_no_floating_ip : 0}"
  instance_id = "${element(openstack_compute_instance_v2.glusterfs_node_no_floating_ip.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.glusterfs_volume.*.id, count.index)}"
}

resource "openstack_compute_volume_attach_v2" "glusterfs_volume_custom_root_volume_size" {
  count       = "${var.gfs_root_volume_size_in_gb > 0 ? var.number_of_gfs_nodes_no_floating_ip : 0}"
  instance_id = "${element(openstack_compute_instance_v2.glusterfs_node_no_floating_ip_custom_volume_size.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.glusterfs_volume_custom_volume_size.*.id, count.index)}"
}
