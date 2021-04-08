pipeline {
    agent { docker { image 'python:3.7.2' } }
    stages {
        stage('build') {
            steps {
                sh 'pip install flask'
                sh 'app/manage.py db init'
                sh 'app/manage.py db migrate'
                sh 'app/manage.py db upgrade'
            }
        }
        stage('test') {
            steps {
                sh 'echo hello world!'
            }
        }
    }
}
