# allow address pairs calico
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
