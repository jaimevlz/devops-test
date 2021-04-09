pipeline {
  agent { docker { image 'python:3-Alpine'} }
  stages {
    stage('build') {
      steps {
      withEnv(["HOME=${env.WORKSPACE}"]) {
                 sh 'pip install --user -r requirements.txt'
             }
      }
    }
    stage('test') {
      steps {
        sh 'python test.py'
      }
      post {
        always {
          junit 'test-reports/*.xml'
        }
      }
    }
  }
}
