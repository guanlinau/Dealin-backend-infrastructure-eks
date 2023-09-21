terraform {
  backend "s3" {
    bucket         = "offerripple-terraform-state"
    key            = "offerripple-backend-cluster-eks.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "offerripple-backend-lock-dynamodb"

  }
}

