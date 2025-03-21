pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nadinc/mvn"
        DOCKER_TAG = "latest"
        DOCKER_CREDENTIALS_ID = "e752556d-0bc6-4985-ad16-6f2a663ce000"
        
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/nadin-c/MVNM_project.git', branch: 'main'
            }
        }

        stage('Build Application') {
            steps {
                script {try {
                         sh '${MAVEN_HOME}/bin/mvn clean package -DskipTests'
                    } catch (Exception e) {
                         sh 'mvn test -Dmaven.test.failure.ignore=true'
                        echo "Tests failed, but proceeding..."
                    }
                   
                }
            }
        }

        stage('Run Maven Tests') {
            steps {
                script {
                    try {
                        sh 'mvn test'
                    } catch (Exception e) {
                         sh 'mvn test -Dmaven.test.failure.ignore=true'
                        echo "Tests failed, but proceeding..."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }
        stage('Login to Docker Hub') {
            steps {
                echo "Logging into Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'e752556d-0bc6-4985-ad16-6f2a663ce000', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                sh "docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKER_IMAGE:$DOCKER_TAG"
                sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
            }
        }

        stage('Deploy Docker Container') {
            steps {
                echo "Deploying Docker container..."
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
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
