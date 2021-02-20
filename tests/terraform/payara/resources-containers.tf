data docker_registry_image "PAYARA" {
  name = var.payara_image
}

resource docker_image "PAYARA" {
  name          = data.docker_registry_image.PAYARA.name
  pull_triggers = [data.docker_registry_image.PAYARA.sha256_digest]
  keep_locally  = true
}

resource docker_container "PAYARA" {
  name  = "payara"
  image = docker_image.PAYARA.latest

  networks = [docker_network.]

  ports {
    internal = 80
    external = 8080
  }
}
