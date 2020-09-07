# poder excluir los master nodes del service CIDR advertising
#   desde rack 69 fisicos no llego a http://10.232.23.94:8080 cuando es extTraffPolicy Cluster, porque rutea por el master que tiene security group restringido
#   y ademas esta mal que pase por el master
#   https://github.com/projectcalico/calico/issues/1604
#   https://github.com/projectcalico/calico/issues/3365#issuecomment-660202663
resource "openstack_networking_secgroup_rule_v2" "master_tcp" {
  security_group_id = "${openstack_networking_secgroup_v2.k8s_master.id}"
  count             = "${length(var.worker_allowed_ports)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "${lookup(var.worker_allowed_ports[count.index], "protocol", "tcp")}"
  port_range_min    = "${lookup(var.worker_allowed_ports[count.index], "port_range_min")}"
  port_range_max    = "${lookup(var.worker_allowed_ports[count.index], "port_range_max")}"
  remote_ip_prefix  = "${lookup(var.worker_allowed_ports[count.index], "remote_ip_prefix", "0.0.0.0/0")}"
}

data "template_file" "user_data" {
  template = file("${path.module}/despegar_nodes/user-data.tpl")

  vars = {
    cluster_domain = var.cluster_domain
  }
}

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

# allow SNMP
resource "openstack_networking_secgroup_rule_v2" "k8s_snmp" {
  count             = "${length(var.k8s_allowed_remote_ips)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 161
  port_range_max    = 161
  remote_ip_prefix  = "${var.k8s_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}

# allow NTP from nagios
resource "openstack_networking_secgroup_rule_v2" "k8s_ntp" {
  count             = "${length(var.k8s_allowed_remote_ips)}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 123
  port_range_max    = 123
  remote_ip_prefix  = "${var.k8s_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}
resource "openstack_networking_secgroup_rule_v2" "k8s_ntp_e" {
  count             = "${length(var.k8s_allowed_remote_ips)}"
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 123
  port_range_max    = 123
  remote_ip_prefix  = "${var.k8s_allowed_remote_ips[count.index]}"
  security_group_id = "${openstack_networking_secgroup_v2.k8s.id}"
}
