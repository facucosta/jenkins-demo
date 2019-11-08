pipeline {
  agent {
    dockerfile {
      dir 'test_env'
      additionalBuildArgs '--build-arg LISTEN_PORT=80'
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
        sh './jenkins/run_test.sh localhost 80'
        sh './jenkins/kill_env.sh'
      }
    }
  }
}
