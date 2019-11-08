pipeline {
  agent {
    docker {
      image 'debian:buster'
      args '-p 5000:80'
    }
  }
  stages {
    stage('Build') {
      steps {
        sh 'ls -la'
        sh 'ps aux'
        sh 'pwd'
      }
    }
  }
}