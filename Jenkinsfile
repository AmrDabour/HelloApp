pipeline {
    agent any
    
    environment {
        AWS_REGION = 'eu-west-1'  
        TF_VERSION = '1.5.0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
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
                script {
                    sh 'terraform plan -out=tfplan'
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
        //         script {
        //             sh 'terraform apply -auto-approve tfplan'
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
