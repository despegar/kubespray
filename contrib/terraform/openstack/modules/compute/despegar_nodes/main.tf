resource "openstack_compute_instance_v2" "k8s_despegar_node" {
  name              = "${var.cluster_name}-node-${var.node_type}-${count.index + 1}"
  count             = "${var.number_of_k8s_nodes}"
  availability_zone = "${element(var.az_list_node, count.index)}"
  image_name        = "${var.image}"
  flavor_id         = "${var.flavor_k8s_node}"
  key_pair          = "${var.key_pair}"

  dynamic "block_device" {
    for_each = var.node_root_volume_size_in_gb > 0 ? [var.image] : []
    content {
      uuid                  = "${data.openstack_images_image_v2.vm_image.id}"
      source_type           = "image"
      volume_size           = "${var.node_root_volume_size_in_gb}"
      boot_index            = 0
      destination_type      = "volume"
      delete_on_termination = true
    }
  }

  network {
    name = "${var.network_name}"
  }

  security_groups = var.secgroups

  metadata = {
    ssh_user                 = "${var.ssh_user}"
    kubespray_groups         = "kube-node,k8s-cluster,no-floating,${var.supplementary_node_groups}"
    depends_on               = "${var.network_id}"
    use_access_ip            = "${var.use_access_ip}"
    kube_service_addresses   = "${var.kube_service_addresses}"
    kube_pods_subnet         = "${var.kube_pods_subnet}"
  }

}
