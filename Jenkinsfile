pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }
            steps {
                sh 'app/manage.py db init'
                sh 'manage.py db migrate'
                sh 'manage.py db upgrade'
            }
        }
    }
}
