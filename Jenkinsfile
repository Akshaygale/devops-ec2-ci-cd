// #pipelinemahe by me #
pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-access-key')
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
                sh '''
                cd terraform
                terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                cd terraform
                terraform plan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                cd terraform
                terraform apply -auto-approve
                '''
            }
        }

        stage('Deploy Frontend') {
            steps {
                sh '''
                cd frontend
                python3 -m http.server 8000 &
                '''
            }
        }

        stage('Deploy Backend') {
            steps {
                sh '''
                cd backend
                python3 app.py &
                '''
            }
        }
    }
}
