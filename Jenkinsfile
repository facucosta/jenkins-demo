pipeline {
  agent {
    docker {
      image 'redis_app'
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