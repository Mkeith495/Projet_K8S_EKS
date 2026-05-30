resource "aws_ecr_repository" "gestion_produits" {
  name                 = "gestion-produits"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
