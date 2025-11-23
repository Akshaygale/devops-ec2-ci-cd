pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git credentialsId: 'github-token',
                    url: 'https://github.com/Akshaygale/devops-ec2-ci-cd.git',
                    branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Frontend') {
            steps {
                dir('frontend') {
                    // Run frontend server safely in background
                    sh 'nohup python3 -m http.server 8000 > frontend.log 2>&1 &'
                    sh 'echo "Frontend server started on port 8000"'
                }
            }
        }

        stage('Deploy Backend') {
            steps {
                dir('backend') {
                    // Run backend app safely in background
                    sh 'nohup python3 app.py > backend.log 2>&1 &'
                    sh 'echo "Backend app started"'
                }
            }
        }

    } // end of stages

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}
