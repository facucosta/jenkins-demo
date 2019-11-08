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
        sh 'cd application && ls -la && ps aux'
        sh 'cd application && cat package.json'
        sh 'cd application && npm install express body-parser redis'
        sh 'cd application'
      }
    }

    stage('Test') {
      steps {
        sh 'service nginx start'
        sh 'service redis-server start'
        sh 'cd application && ls -la && ps aux'
        sh 'nodejs ./application/index.js &'
        sh './tests/run_test.sh'
      }
    }
  }
}