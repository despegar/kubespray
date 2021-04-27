variable "master_index" {}

variable "cluster_name" {}

variable "cluster_node_prefix" {}

variable "dns_zone" {}

variable "cluster_domain" {}

variable "az_list" {
  type = list(string)
}

variable "az_list_node" {
  type = list(string)
}

variable "number_of_k8s_masters" {}

variable "master_root_volume_size_in_gb" {}

variable "image" {}

variable "ssh_user" {}

variable "flavor_k8s_master" {}

variable "network_name" {}

variable "network_id" {
  default = ""
}

variable "use_access_ip" {}

variable "key_pair" {}

variable "secgroups" {}

variable "supplementary_master_groups" {}

variable "kube_service_addresses" {}

variable "kube_pods_subnet" {}
