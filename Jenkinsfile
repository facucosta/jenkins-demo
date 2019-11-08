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
        sh './jenkins/build_app.sh'
      }
    }

    stage('Test') {
      steps {
        sh './jenkins/setup_env.sh'
        sh './jenkins/run_test.sh localhost 8081'
        sh './jenkins/kill_env.sh'
      }
    }
  }
}
