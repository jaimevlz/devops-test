pipeline {
  agent { docker { image 'python:3.7.2' } }
  stages {
    stage('build') {
      steps {
        sh 'echo $HOME'
        withEnv(["HOME=${env.WORKSPACE}"]) {
          sh 'pip install --user -r requirements.txt'
        }
      }
    }
    stage('test') {
      steps {
        sh 'echo $HOME'
        withEnv(["HOME=${env.WORKSPACE}"]) {
          sh 'python test.py'
        }
      }
      post {
        always {
          junit 'test-reports/*.xml'
        }
      }
    }
  }
}
