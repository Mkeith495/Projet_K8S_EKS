output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "region" {
  value = var.aws_region
}

output "efs_file_system_id" {
  value = aws_efs_file_system.this.id
}

output "storage_class_name" {
  value = kubernetes_storage_class.efs.metadata[0].name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.gestion_produits.repository_url
}
