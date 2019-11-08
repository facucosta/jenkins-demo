pipeline {
  agent {
    docker {
      image 'redis_app'
      args '-p 5000:80'
    }

  }
  stages {
    stage('Test') {
      steps {
        sh './tests/run_test.sh'
      }
    }

  }
}