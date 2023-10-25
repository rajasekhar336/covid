pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t rajatherise/covid .'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    sh """sonar-scanner \\
                        -Dsonar.projectKey=covid \\
                        -Dsonar.sources=. \\
                        -Dsonar.host.url=http://52.66.235.10:9000 \\
                        -Dsonar.login=sonarqube
                    """
                }
            }
        }

        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push') {
            steps {
                sh 'docker push rajatherise/covid'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubernetes', variable: 'KUBECONFIG_FILE')]) {
                    sh """
                        export KUBECONFIG=\$KUBECONFIG_FILE
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
