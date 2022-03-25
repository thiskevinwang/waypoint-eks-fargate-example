project = "testing1"

app "api" {
  build {
    use "docker" {
      buildkit           = false
      disable_entrypoint = false
      platform           = "amd64"
    }

    registry {
      use "aws-ecr" {
        repository = "hashicorp-dev-hello-world"
        region     = "us-east-1"
        tag        = "v1"
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      namespace  = "waypoint-apps"
    }
  }
}
