module "nodes_type1" {
  source = "./despegar_nodes"

  node_type                                    = "t01"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[0]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[0]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type2" {
  source = "./despegar_nodes"

  node_type                                    = "t02"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[1]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[1]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type3" {
  source = "./despegar_nodes"

  node_type                                    = "t03"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[2]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[2]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type4" {
  source = "./despegar_nodes"

  node_type                                    = "t04"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[3]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[3]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type5" {
  source = "./despegar_nodes"

  node_type                                    = "t05"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[4]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[4]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type6" {
  source = "./despegar_nodes"

  node_type                                    = "t06"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[5]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[5]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type7" {
  source = "./despegar_nodes"

  node_type                                    = "t07"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[6]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[6]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type8" {
  source = "./despegar_nodes"

  node_type                                    = "t08"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[7]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[7]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type9" {
  source = "./despegar_nodes"

  node_type                                    = "t09"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[8]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[8]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}

module "nodes_type10" {
  source = "./despegar_nodes"

  node_type                                    = "t10"
  cluster_name                                 = var.cluster_name
  cluster_node_prefix                          = var.cluster_node_prefix
  az_list                                      = var.az_list
  az_list_node                                 = var.az_list_node
  number_of_k8s_nodes                          = var.despegar_k8s_nodes[9]["q"]
  node_root_volume_size_in_gb                  = var.node_root_volume_size_in_gb
  image                                        = var.image
  ssh_user                                     = var.ssh_user
  flavor_k8s_node                              = var.despegar_k8s_nodes[9]["flavor"]
  network_name                                 = var.network_name
  network_id                                   = var.network_id
  use_access_ip                                = var.use_access_ip
  key_pair                                     = openstack_compute_keypair_v2.k8s.name
  secgroups                                    = [openstack_networking_secgroup_v2.k8s.name, openstack_networking_secgroup_v2.worker.name]
  supplementary_node_groups                    = var.supplementary_node_groups
  kube_service_addresses                       = var.kube_service_addresses
  kube_pods_subnet                             = var.kube_pods_subnet
  dns_zone                                     = var.dns_zone
  cluster_domain                               = var.cluster_domain
}
