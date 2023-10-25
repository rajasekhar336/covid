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

       stage('Build and SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool name: 'SonarQubeScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    withEnv(["PATH+SONARQUBE_SCANNER=${scannerHome}/bin"]) {
                        sh '''
                            # Install dependencies and build your PHP project
                            composer install
                            # Run SonarQube analysis
                            sonar-scanner
                        '''
                    }
                }
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
