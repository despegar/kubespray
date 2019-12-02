variable "subnets" {
  type        = list(string)
  default     = ["d85e2b9e-f9e2-45e5-82d4-8990830cac49","0ba57227-231e-486a-a196-a2ae5c0521c6"]
}
variable "rr_ips" {
  type        = list(string)
  default     = ["10.184.42.241", "10.184.46.241"]
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
  count          = length(var.subnets)
  admin_state_up = "true"

  network_id     = "${var.provider_network_id}"
  # neutron/policy.json get_port, create_port:fixed_ips:subnet_id y create_port:fixed_ips:ip_address a ""
  fixed_ip {
     subnet_id  = var.subnets[count.index]
     ip_address = var.rr_ips[count.index]
  }

  security_group_ids = [
     "${openstack_networking_secgroup_v2.k8s.id}",
     "${openstack_networking_secgroup_v2.rr.id}"
   ]
}
