variable "cluster_name" {}

variable "az_list" {
  type = list(string)
}

variable "az_list_node" {
  type = list(string)
}

variable "number_of_k8s_nodes" {}

variable "node_root_volume_size_in_gb" {}

variable "image" {}

variable "ssh_user" {}

variable "flavor_k8s_node" {}

variable "network_name" {}

variable "network_id" {
  default = ""
}

variable "use_access_ip" {}

variable "key_pair" {}

variable "secgroups" {}

variable "supplementary_node_groups" {}
