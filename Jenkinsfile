pipeline {
  agent { docker { image 'python:3.7.2' } }
  stages {
    stage('Build') {
      steps {
        sh 'echo $HOME'
        withEnv(["HOME=${env.WORKSPACE}"]) {
          sh 'pip install --user -r requirements.txt'
        }
      }
    }
    stage('Test') {
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
    stage('Deliver') {
      agent any
      environment {
        VOLUME = '$(pwd)/sources:/src'
        IMAGE = 'python:3.7.2'
      }
      steps {
        dir(path: env.BUILD_ID) {
          unstash(name: 'compiled-results')
          sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F app.py'"
        }
      }
      post {
        success {
          sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
        }
      }
    }
  }
}
