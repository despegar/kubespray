# SMALL
resource "openstack_compute_instance_v2" "k8s_node_small" {
  name              = "${var.cluster_name}-k8s-node-small-${count.index + 1}"
  count             = "${var.number_of_k8s_nodes_small}"
  availability_zone = "${element(var.az_list_node, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_node_small}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  dynamic "block_device" {
    for_each = var.node_root_volume_size_in_gb > 0 ? [var.image] : []
    content {
      uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
      source_type           = "image"
      volume_size           = "${var.node_root_volume_size_in_gb}"
      boot_index            = 0
      destination_type      = "volume"
      delete_on_termination = true
    }
  }

  network {
    port = "${element(openstack_networking_port_v2.k8s_node_small.*.id, count.index)}"
  }

  dynamic "scheduler_hints" {
    for_each = var.use_server_groups ? [openstack_compute_servergroup_v2.k8s_node[0]] : []
    content {
      group = "${openstack_compute_servergroup_v2.k8s_node[0].id}"
    }
  }

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
    use_access_ip    = "${var.use_access_ip}"
    AS               = "${lookup(element(var.bgp_peerings, count.index), "as")}"
    RR               = "${lookup(element(var.bgp_peerings, count.index), "ip", "")}"
    RRBKP            = "${length(var.bgp_peerings_bkp) > 0 ? lookup(element(var.bgp_peerings_bkp, count.index), "ip") : ""}" # https://github.com/hashicorp/terraform/issues/11210
    TOR              = "${lookup(element(var.bgp_peerings, count.index), "tor")}"
  }
}


# MEDIUM
resource "openstack_compute_instance_v2" "k8s_node_medium" {
  name              = "${var.cluster_name}-k8s-node-medium-${count.index + 1}"
  count             = "${var.number_of_k8s_nodes_medium}"
  availability_zone = "${element(var.az_list_node, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_node_medium}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  dynamic "block_device" {
    for_each = var.node_root_volume_size_in_gb > 0 ? [var.image] : []
    content {
      uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
      source_type           = "image"
      volume_size           = "${var.node_root_volume_size_in_gb}"
      boot_index            = 0
      destination_type      = "volume"
      delete_on_termination = true
    }
  }

  network {
    port = "${element(openstack_networking_port_v2.k8s_node_medium.*.id, count.index)}"
  }

  dynamic "scheduler_hints" {
    for_each = var.use_server_groups ? [openstack_compute_servergroup_v2.k8s_node[0]] : []
    content {
      group = "${openstack_compute_servergroup_v2.k8s_node[0].id}"
    }
  }

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "kube-node,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
    use_access_ip    = "${var.use_access_ip}"
    AS               = "${lookup(element(var.bgp_peerings, count.index), "as")}"
    RR               = "${lookup(element(var.bgp_peerings, count.index), "ip", "")}"
    RRBKP            = "${length(var.bgp_peerings_bkp) > 0 ? lookup(element(var.bgp_peerings_bkp, count.index), "ip") : ""}" # https://github.com/hashicorp/terraform/issues/11210
    TOR              = "${lookup(element(var.bgp_peerings, count.index), "tor")}"
  }
}
