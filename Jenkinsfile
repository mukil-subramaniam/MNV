pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mukil077/mvn"
        DOCKER_TAG = "latest"
        DOCKER_CREDENTIALS_ID = "4ae4f62c-faf0-4b57-823c-d70961eef605"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/mukil-subramaniam/MNV.git', branch: 'main'
            }
        }

        stage('Build Application') {
            steps {
                script {
                    try {
                        sh 'mvn clean package -DskipTests'
                    } catch (Exception e) {
                        echo "Build failed: ${e}"
                        currentBuild.result = 'FAILURE'
                        error('Pipeline failed due to build error')
                    }
                }
            }
        }

        stage('Run Maven Tests') {
            steps {
                script {
                    try {
                        sh 'mvn test -Dmaven.test.failure.ignore=true'
                    } catch (Exception e) {
                        echo "Tests failed, but proceeding..."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    try {
                        sh 'chmod +x build.sh'
                        sh './build.sh'
                    } catch (Exception e) {
                        echo "Docker build failed: ${e}"
                        currentBuild.result = 'FAILURE'
                        error('Pipeline failed due to Docker build error')
                    }
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo "Logging into Docker Hub..."
                withCredentials([usernamePassword(credentialsId: env.DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                script {
                    try {
                        sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
                    } catch (Exception e) {
                        echo "Docker push failed: ${e}"
                        currentBuild.result = 'FAILURE'
                        error('Pipeline failed due to Docker push error')
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                echo "Deploying Docker container..."
                script {
                    try {
                        sh 'chmod +x deploy.sh'
                        sh './deploy.sh'
                    } catch (Exception e) {
                        echo "Deployment failed: ${e}"
                        currentBuild.result = 'FAILURE'
                        error('Pipeline failed due to deployment error')
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Deployment Failed!"
        }
    }
}
