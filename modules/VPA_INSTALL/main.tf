# resource-0: Configure kubeconfig via aws cli
resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
  }
}

# Resource-1: Null Resource: Clone GitHub Repository
resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command = "${var.git_clone_command} ${path.module}/autoscaler"
  }
}

# # Resource-2: Null Resource: Install Vertical Pod Autoscaler
resource "null_resource" "install_vpa" {
  depends_on = [null_resource.git_clone]
  provisioner "local-exec" {
    command = "${path.module}/${var.install_vpa_path}"
  }
}

# Resource-3: Null Resource: Remove autoscaler folder
resource "null_resource" "remove_git_clone_autoscaler_folder" {
  triggers = {
    path = "${path.module}/${var.removed_folder}"
  }
  provisioner "local-exec" {
    command = "rm -rf  ${self.triggers.path}"
    when    = destroy
  }
}

# Resource-4: Null Resource: Uninstall Vertical Pod Autoscaler
resource "null_resource" "uninstall_vpa" {
  depends_on = [null_resource.remove_git_clone_autoscaler_folder]
  triggers = {
    path = "${path.module}/${var.uninstall_vpa_path}"
  }
  provisioner "local-exec" {
    command = self.triggers.path
    when    = destroy
  }
}
