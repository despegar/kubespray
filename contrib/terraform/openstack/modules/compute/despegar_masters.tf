module "master_index1" {
  source = "./despegar_masters"

  master_index                                   = "1"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[0]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[0]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}

module "master_index2" {
  source = "./despegar_masters"

  master_index                                   = "2"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[1]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[1]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}

module "master_index3" {
  source = "./despegar_masters"

  master_index                                   = "3"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[2]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[2]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}

module "master_index4" {
  source = "./despegar_masters"

  master_index                                   = "4"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[3]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[3]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}

module "master_index5" {
  source = "./despegar_masters"

  master_index                                   = "5"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[4]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[4]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}

module "master_index6" {
  source = "./despegar_masters"

  master_index                                   = "6"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[5]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[5]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}

module "master_index7" {
  source = "./despegar_masters"

  master_index                                   = "7"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[6]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[6]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}

module "master_index8" {
  source = "./despegar_masters"

  master_index                                   = "8"
  cluster_name                                 = "${var.cluster_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_k8s_masters                        = "${var.despegar_k8s_masters[7]["q"]}"
  master_root_volume_size_in_gb                = "${var.master_root_volume_size_in_gb}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor_k8s_master                            = "${var.despegar_k8s_masters[7]["flavor"]}"
  network_name                                 = "${var.network_name}"
  network_id                                   = "${var.network_id}"
  use_access_ip                                = "${var.use_access_ip}"
  key_pair                                     = "${openstack_compute_keypair_v2.k8s.name}"
  secgroups                                    = ["${openstack_networking_secgroup_v2.k8s.name}", "${openstack_networking_secgroup_v2.k8s_master.name}" ]
  supplementary_master_groups                  = "${var.supplementary_master_groups}"
  kube_service_addresses                       = "${var.kube_service_addresses}"
  kube_pods_subnet                             = "${var.kube_pods_subnet}"
  cluster_domain                               = "${var.cluster_domain}"
}
