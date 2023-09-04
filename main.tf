terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 2.0.0"
    }
  }
}

resource "docker_network" "jenkins" {
  name = "jenkins"
}
resource "docker_volume" "jenkins_home" {
  name = "jenkins_home"
}

resource "docker_container" "jenkins" {
  image = "jenkins/jenkins"
  name = "jenkins"
  ports {
    internal = 8080
    external = 8080
  }
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
    volumes {
    host_path      = "/usr/bin/docker"
    container_path = "/usr/bin/docker"
  }
  network_mode = "bridge"
  networks_advanced {
  name = docker_network.jenkins.name
  }
}
