pipeline {
  agent {
    docker {
      image 'redis_app'
      args '-p 5000:80'
    }
  }
  stages {
    /*stage('Build') {
      steps {
        sh 'npm install'
      }
    }*/

    stage('Test') {
      steps {
        sh './tests/run_test.sh localhost 80'
      }
    }

    /*stage('Deliver') {
      steps {
        sh './jenkins/scripts/deliver.sh'
        input 'Finished using the web site? (Click "Proceed" to continue)'
        sh './jenkins/scripts/kill.sh'
      }
    }*/
  }
}