terraform {
  required_providers {
    kubernetes = "2.20.0"
  }
}

resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }

      spec {
        container {
          image = "jenkins/jenkins:lts"
          name  = "jenkins"

          ports {
            container_port = 8080
          }

          volume_mount {
            name      = "jenkins-data"
            mount_path = "/var/jenkins_home"
          }
        }

        volume {
          name = "jenkins-data"

          host_path {
            path = "/tmp/jenkins-data"
          }
        }
      }
    }
  }
}