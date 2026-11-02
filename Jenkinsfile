pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'sree6303'
        IMAGE_NAME     = "${DOCKERHUB_USER}/cicd-flask-app"
        IMAGE_TAG      = "${BUILD_NUMBER}"
    }

    options {
        skipDefaultCheckout(true)
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git log -1 --oneline'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG -t $IMAGE_NAME:latest .'
            }
        }

        stage('Test') {
            steps {
                sh 'docker run --rm $IMAGE_NAME:$IMAGE_TAG python -m pytest -v -p no:cacheprovider'
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DH_USER',
                    passwordVariable: 'DH_TOKEN'
                )]) {
                    sh '''
                        echo "$DH_TOKEN" | docker login -u "$DH_USER" --password-stdin
                        docker push $IMAGE_NAME:$IMAGE_TAG
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'ansible-playbook --syntax-check -i ansible/inventory.ini ansible/deploy.yml'
                sh 'ansible-playbook -i ansible/inventory.ini ansible/deploy.yml -e image_tag=$IMAGE_TAG'
            }
        }
    }

    post {
        success {
            echo "✅ Deployed ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed. Check the stage logs above."
        }
        always {
            sh 'docker logout || true'
            sh 'docker image prune -f || true'
        }
    }
}