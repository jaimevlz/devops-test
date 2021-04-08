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
                sh 'python manage.py db init'
                sh 'python manage.py db migrate'
                sh 'python manage.py db upgrade'
                sh 'python -m py_compile app/app.py'
                stash(name: 'compiled-results', includes: 'app/*.py*')

            }
        }
    }
}
