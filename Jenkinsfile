
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPOSITORY = 'myapp-dev'
        ECS_CLUSTER = 'myapp-dev'
        ECS_SERVICE = 'myapp-dev-service'
        TASK_FAMILY = 'myapp-dev'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('application') {
                    sh 'npm ci'
                }
            }
        }

        stage('Unit Testing') {
            steps {
                dir('application') {
                    sh 'npm test'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('application') {
                    script {
                        def scannerHome = tool 'SonarScanner'

                        withSonarQubeEnv('SonarQube') {
                            sh "${scannerHome}/bin/sonar-scanner"
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()

                        if (qg.status != 'OK') {
                            error "Quality Gate failed: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Prepare ECR Details') {
            steps {
                script {
                    def accountId = sh(
                        script: 'aws sts get-caller-identity --query Account --output text',
                        returnStdout: true
                    ).trim()

                    env.ECR_REGISTRY =
                        "${accountId}.dkr.ecr.${env.AWS_REGION}.amazonaws.com"

                    env.IMAGE_URI =
                        "${env.ECR_REGISTRY}/${env.ECR_REPOSITORY}"
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build \
                      -t "$IMAGE_URI:$BUILD_NUMBER" \
                      -t "$IMAGE_URI:latest" \
                      application
                '''
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh '''
                    trivy image \
                      --exit-code 0 \
                      --severity HIGH,CRITICAL \
                      "$IMAGE_URI:$BUILD_NUMBER"
                '''
            }
        }

        stage('Push to AWS ECR') {
            steps {
                sh '''
                    aws ecr get-login-password \
                      --region "$AWS_REGION" \
                    | docker login \
                      --username AWS \
                      --password-stdin "$ECR_REGISTRY"

                    docker push "$IMAGE_URI:$BUILD_NUMBER"
                    docker push "$IMAGE_URI:latest"
                '''
            
        }
    }

    stage('Register ECS Task Definition') {
    steps {
        script {
            env.TASK_DEF_ARN = sh(
                script: '''
                    aws ecs describe-task-definition \
                      --task-definition "$TASK_FAMILY" \
                      --region "$AWS_REGION" \
                      --query taskDefinition > task-def.json

                    jq --arg image "$IMAGE_URI:$BUILD_NUMBER" '
                      del(
                        .taskDefinitionArn,
                        .revision,
                        .status,
                        .requiresAttributes,
                        .compatibilities,
                        .registeredAt,
                        .registeredBy,
                        .deregisteredAt
                      )
                      | .containerDefinitions[0].image = $image
                    ' task-def.json > new-task-def.json

                    aws ecs register-task-definition \
                      --cli-input-json file://new-task-def.json \
                      --region "$AWS_REGION" \
                      --query 'taskDefinition.taskDefinitionArn' \
                      --output text
                ''',
                returnStdout: true
            ).trim()

            echo "Registered Task Definition: ${env.TASK_DEF_ARN}"
        }
    }
}

stage('Deploy to ECS') {
    steps {
        sh '''
            aws ecs update-service \
              --cluster "$ECS_CLUSTER" \
              --service "$ECS_SERVICE" \
              --task-definition "$TASK_DEF_ARN" \
              --desired-count 1 \
              --region "$AWS_REGION"

            aws ecs wait services-stable \
              --cluster "$ECS_CLUSTER" \
              --services "$ECS_SERVICE" \
              --region "$AWS_REGION"
        '''
    }
 }
}

    post {
        success {
            echo 'CICD Pipeline completed successfully!'
        }

        failure {
            echo 'CICD Pipeline failed. Please check the stage logs.'
        }
    }
}
