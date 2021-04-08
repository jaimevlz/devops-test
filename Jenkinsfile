pipeline {
    agent { docker { image 'python:3.7.2' } }
    stages {
        stage('build') {
            steps {
                sh 'sudo pip install flask'
            }
        }
        stage('test') {
            steps {
                sh 'sudo python test.py'
            }
        }
    }
}
