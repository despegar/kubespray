# allow ping
resource "openstack_networking_secgroup_rule_v2" "k8s_icmp_i" {
  count             = "${length(var.k8s_allowed_remote_ips)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "${var.k8s_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_icmp_e" {
  count             = "${length(var.k8s_allowed_remote_ips)}"
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "${var.k8s_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}
