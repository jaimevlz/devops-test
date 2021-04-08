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
                sh 'app/manage.py db migrate'
                sh 'app/manage.py db upgrade'
                sh 'app/app.py'
            }
        }
    }
}
