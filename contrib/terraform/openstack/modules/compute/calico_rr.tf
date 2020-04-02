resource "openstack_networking_secgroup_v2" "rr" {
  count = "${var.flavor_calico_rr != "" ? 1 : 0}"
  name                 = "${var.cluster_name}-rr"
  description          = "${var.cluster_name} - Calico Route Reflector"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "rr" {
  count = "${var.flavor_calico_rr != "" ? 1 : 0}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "179"
  port_range_max    = "179"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.rr[0].id}"
}

resource "openstack_networking_secgroup_rule_v2" "rr-tcp" {
  count             = "${length(var.worker_allowed_ports)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "${lookup(var.worker_allowed_ports[count.index], "protocol", "tcp")}"
  port_range_min    = "${lookup(var.worker_allowed_ports[count.index], "port_range_min")}"
  port_range_max    = "${lookup(var.worker_allowed_ports[count.index], "port_range_max")}"
  remote_ip_prefix  = "${lookup(var.worker_allowed_ports[count.index], "remote_ip_prefix", "0.0.0.0/0")}"
  security_group_id = "${openstack_networking_secgroup_v2.rr[0].id}"
}

# RR PRIMARY
resource "openstack_networking_port_v2" "k8s_calico_rr" {
  name           = "${var.cluster_name}-k8s-calico-rr-${count.index+1}"
  count          = "${var.flavor_calico_rr != "" ? length(var.bgp_peerings) : 0}"
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"
  # neutron/policy.json get_port, create_port:fixed_ips:subnet_id y create_port:fixed_ips:ip_address a ""
  fixed_ip {
     subnet_id  = var.bgp_peerings[count.index].subnet
     ip_address = var.bgp_peerings[count.index].ip
  }

  security_group_ids = [
     "${openstack_networking_secgroup_v2.k8s.id}",
     "${openstack_networking_secgroup_v2.rr[0].id}"
   ]

  allowed_address_pairs {
    ip_address = "${var.kube_service_addresses}"
  }
  allowed_address_pairs {
    ip_address = "${var.kube_pods_subnet}"
  }
}

resource "openstack_compute_instance_v2" "k8s_calico_rr" {
  name              = "${var.cluster_name}-k8s-calico-rr-${var.bgp_peerings[count.index].as}"
  count             = "${var.flavor_calico_rr != "" ? length(var.bgp_peerings) : 0}"
  availability_zone = "${var.bgp_peerings[count.index].az}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_calico_rr}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    port = "${element(openstack_networking_port_v2.k8s_calico_rr.*.id, count.index)}"
  }

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "calico-rr,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
    node_taints      = "calico-rr=true:NoSchedule"
    cluster_id       = var.bgp_peerings[count.index].id
    AS               = var.bgp_peerings[count.index].as
    RR               = var.bgp_peerings[count.index].ip
    TOR              = var.bgp_peerings[count.index].tor
  }
}

# RR BACKUP
resource "openstack_networking_port_v2" "k8s_calico_rr_bkp" {
  name           = "${var.cluster_name}-k8s-calico-rr-${count.index+1}-bkp"
  count          = "${var.flavor_calico_rr != "" ? length(var.bgp_peerings_bkp) : 0}"
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"
  # neutron/policy.json get_port, create_port:fixed_ips:subnet_id y create_port:fixed_ips:ip_address a ""
  fixed_ip {
     subnet_id  = var.bgp_peerings_bkp[count.index].subnet
     ip_address = var.bgp_peerings_bkp[count.index].ip
  }

  security_group_ids = [
     "${openstack_networking_secgroup_v2.k8s.id}",
     "${openstack_networking_secgroup_v2.rr[0].id}"
   ]

  allowed_address_pairs {
    ip_address = "${var.kube_service_addresses}"
  }
  allowed_address_pairs {
    ip_address = "${var.kube_pods_subnet}"
  }
}

resource "openstack_compute_instance_v2" "k8s_calico_rr_bkp" {
  name              = "${var.cluster_name}-k8s-calico-rr-${var.bgp_peerings_bkp[count.index].as}-bkp"
  count             = "${var.flavor_calico_rr != "" ? length(var.bgp_peerings_bkp) : 0}"
  availability_zone = "${var.bgp_peerings_bkp[count.index].az}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_calico_rr}"
  key_pair          = "${openstack_compute_keypair_v2.k8s.name}"

  network {
    port = "${element(openstack_networking_port_v2.k8s_calico_rr_bkp.*.id, count.index)}"
  }

  metadata = {
    ssh_user         = "${var.ssh_user}"
    kubespray_groups = "calico-rr,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on       = "${var.network_id}"
    node_taints      = "calico-rr=true:NoSchedule"
    cluster_id       = var.bgp_peerings_bkp[count.index].id
    AS               = var.bgp_peerings_bkp[count.index].as
    RR               = var.bgp_peerings_bkp[count.index].ip
    TOR              = var.bgp_peerings_bkp[count.index].tor
  }
}
