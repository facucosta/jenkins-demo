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
        sh 'cd application && npm install'
      }
    }

    stage('Test') {
      steps {
        sh 'service start nginx'
        sh 'service redis-server start'
        sh 'nodejs ./application/index.js &'
        sh './tests/run_test.sh'
      }
    }
  }
}