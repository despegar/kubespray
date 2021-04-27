module "master_node1" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[0]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[0]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[0]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "master_node2" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[1]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[1]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[1]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "master_node3" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[2]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[2]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[2]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "master_node4" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[3]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[3]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[3]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "master_node5" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[4]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[4]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[4]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "master_node6" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[5]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[5]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[5]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "master_node7" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[6]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[6]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[6]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "master_node8" {
  source = "./despegar_masters"

  master_index                                 = var.despegar_k8s_masters[7]["index"]
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_masters                        = var.despegar_k8s_masters[7]["q"]
  master_root_volume_size_in_gb                = var.master_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_master                            = var.despegar_k8s_masters[7]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.k8s_master.name ]
  supplementary_master_groups                  = var.supplementary_master_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}
