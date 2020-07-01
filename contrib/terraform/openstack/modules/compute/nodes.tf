module "nodes_sm1" {
  source = "./despegar_nodes"

  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = 2
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "1000"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  use_server_groups                            = "${var.use_server_groups}"
}

module "nodes_sm2" {
  source = "./despegar_nodes"

  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = 2
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "1001"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  use_server_groups                            = "${var.use_server_groups}"
}
