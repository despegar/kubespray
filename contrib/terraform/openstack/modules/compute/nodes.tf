module "nodes_type1" {
  source = "./despegar_nodes"

  node_type                                    = "t01"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[0]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[0]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}

module "nodes_type2" {
  source = "./despegar_nodes"

  node_type                                    = "t02"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[1]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[1]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}

module "nodes_type3" {
  source = "./despegar_nodes"

  node_type                                    = "t03"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[2]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[2]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}

module "nodes_type4" {
  source = "./despegar_nodes"

  node_type                                    = "t04"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[3]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[3]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}

module "nodes_type5" {
  source = "./despegar_nodes"

  node_type                                    = "t05"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[4]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[4]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}

module "nodes_type6" {
  source = "./despegar_nodes"

  node_type                                    = "t06"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[5]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[5]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}

module "nodes_type7" {
  source = "./despegar_nodes"

  node_type                                    = "t07"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[6]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[6]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}

module "nodes_type8" {
  source = "./despegar_nodes"

  node_type                                    = "t08"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_nodes                          = "${values(var.despegar_k8s_nodes)[7]}"
  node_root_volume_size_in_gb                  = "${var.node_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_node                              = "${keys(var.despegar_k8s_nodes)[7]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.worker.name}"]
  supplementary_node_groups                    = "${var.supplementary_node_groups}"
}
