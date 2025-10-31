pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        TF_VERSION = '1.5.0'
        AWS_CREDENTIALS_ID = 'aws-credentials'  // Change this to your Jenkins credentials ID
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                withCredentials([aws(credentialsId: "${AWS_CREDENTIALS_ID}", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        sh 'terraform init'
                    }
                }
            }
        }
        
        stage('Terraform Validate') {
            steps {
                script {
                    sh 'terraform validate'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                withCredentials([aws(credentialsId: "${AWS_CREDENTIALS_ID}", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }
        
        stage('Approval') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Approve deployment?', ok: 'Deploy'
            }
        }
        
        // stage('Terraform Apply') {
        //     when {
        //         branch 'main'
        //     }
        //     steps {
        //         withCredentials([aws(credentialsId: "${AWS_CREDENTIALS_ID}", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        //             script {
        //                 sh 'terraform apply -auto-approve tfplan'
        //             }
        //         }
        //     }
        // }
    }
    
    post {
        always {
            deleteDir()
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
