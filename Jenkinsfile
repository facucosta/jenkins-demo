pipeline {
  agent {
    dockerfile {
      dir 'test_env'
      additionalBuildArgs '--build-arg LISTEN_PORT=81'
    }
  }
  stages {
    stage('Build') {
      steps {
        sh 'cd jenkins && ./build_app.sh'
      }
    }

    stage('Test') {
      steps {
        sh './jenkins/setup_env.sh'
        sh 'cat /etc/nginx/sites-available/nginx-redis-app-conf'
        sh 'ps aux'
        sh 'cat /etc/nginx/sites-enabled/nginx-redis-app-conf'
        sh './jenkins/run_test.sh localhost 81'
        sh './jenkins/kill_env.sh'
      }
    }
  }
}
