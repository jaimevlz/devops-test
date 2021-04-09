pipeline {
  agent { docker { image 'python:3.7.2' } }
  stages {
    stage('build') {
      steps {
        sh 'echo $HOME'
        withEnv(["HOME=${env.WORKSPACE}"]) {
          sh 'virtualenv "HOME=${env.WORKSPACE}"''
          sh 'soruce virtualenv env/bin/activate'
          sh 'pip install --user -r requirements.txt'
        }
      }
    }
    stage('test') {
      steps {
        sh 'python test.py'
      }
    }
  }
}
