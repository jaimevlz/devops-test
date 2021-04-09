pipeline {
  agent { docker { image 'python:3.7.2'} }
  stages {
    stage('build') {
      steps {
        sh 'virtualenv venv && . venv/bin/activate && pip install -r requirements.txt && python tests.py'
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
