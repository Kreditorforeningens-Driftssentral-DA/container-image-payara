terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375/"
  #host = "unix://localhost/var/run/docker.sock"
}