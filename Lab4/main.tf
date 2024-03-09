terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Resource for a Docker image
resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

# Resource for a Docker container that implicitly depends on the Docker image
resource "docker_container" "web_app" {
  image = docker_image.nginx.image_id
  name  = "web_app_container"

  ports {
    internal = 80
    external = 8090
  }
}

# Another Docker container resource with explicit dependency on the first container
resource "docker_container" "database" {
  image = "postgres:latest"
  name  = "database_container"

  depends_on = [docker_container.web_app]  # Corrected dependency declaration
}
