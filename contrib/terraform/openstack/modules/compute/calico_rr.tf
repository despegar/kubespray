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

# RR PRIMARY
resource "openstack_networking_port_v2" "k8s_calico_rr" {
  name           = "${var.cluster_name}-k8s-calico-rr-${count.index+1}"
  count          = length(var.calico_rrs)
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"
  # neutron/policy.json get_port, create_port:fixed_ips:subnet_id y create_port:fixed_ips:ip_address a ""
  fixed_ip {
     subnet_id  = var.calico_rrs[count.index].subnet
     ip_address = var.calico_rrs[count.index].ip
  }

  security_group_ids = [
     "${openstack_networking_secgroup_v2.k8s.id}",
     "${openstack_networking_secgroup_v2.rr.id}"
   ]
}

resource "openstack_compute_instance_v2" "k8s_calico_rr" {
  name              = "${var.cluster_name}-k8s-calico-rr-${var.calico_rrs[count.index].as}"
  count             = length(var.calico_rrs)
  availability_zone = "${var.calico_rrs[count.index].az}"
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
    cluster_id       = var.calico_rrs[count.index].id
    AS               = var.calico_rrs[count.index].as
    RR               = var.calico_rrs[count.index].ip
    TOR              = var.calico_rrs[count.index].tor
  }
}

# RR BACKUP
resource "openstack_networking_port_v2" "k8s_calico_rr_bkp" {
  name           = "${var.cluster_name}-k8s-calico-rr-${count.index+1}-bkp"
  count          = length(var.calico_rrs_bkp)
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"
  # neutron/policy.json get_port, create_port:fixed_ips:subnet_id y create_port:fixed_ips:ip_address a ""
  fixed_ip {
     subnet_id  = var.calico_rrs_bkp[count.index].subnet
     ip_address = var.calico_rrs_bkp[count.index].ip
  }

  security_group_ids = [
     "${openstack_networking_secgroup_v2.k8s.id}",
     "${openstack_networking_secgroup_v2.rr.id}"
   ]
}

resource "openstack_compute_instance_v2" "k8s_calico_rr_bkp" {
  name              = "${var.cluster_name}-k8s-calico-rr-${var.calico_rrs_bkp[count.index].as}-bkp"
  count             = length(var.calico_rrs_bkp)
  availability_zone = "${var.calico_rrs_bkp[count.index].az}"
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
    cluster_id       = var.calico_rrs_bkp[count.index].id
    AS               = var.calico_rrs_bkp[count.index].as
    RR               = var.calico_rrs_bkp[count.index].ip
    TOR              = var.calico_rrs_bkp[count.index].tor
  }
}
