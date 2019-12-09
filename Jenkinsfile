pipeline {
    // Agent Windows
    agent any
    
    environment {
        ARM_SUBSCRIPTION_ID      = "98e03152-0027-41fa-a4af-1b6b1100e212"
        ARM_TENANT_ID            = credentials('Terraform-Azure-Tenant_ID')
        ARM_CLIENT_ID            = credentials('Terraform-Azure-Client_ID')
        ARM_CLIENT_SECRET        = credentials('Terraform-Azure-Client-Secret')
        
        // name of container for storage_account_name = "terraformstorageaccount1"
        ARM_STATE_CONTAINER_NAME = "terraform-state-test2-parameter"

        TERRAFORM_PATH           = "${getTerraformPath()}"
        
        // name of terraform workspace: "dev" or "prod" 
        TERRAFORM_WORKSPACE      = "%WORKSPACE%"
    }
    
    stages {
        stage ('terra-create-state-container') {
            steps {
                script {
                    createTerraformStorageContainer()
                }
            }
        }
        stage ('terra-init'){
            steps {
                bat "\"%TERRAFORM_PATH%\\terraform\" init"               
            }
        }
        stage ('terra-create-and-choose-workspace') {
            steps {
                bat label: '', returnStatus: true, script: "\"%TERRAFORM_PATH%\\terraform\" workspace new %TERRAFORM_WORKSPACE%"
                bat "\"%TERRAFORM_PATH%\\terraform\" workspace select %TERRAFORM_WORKSPACE%"
            }
        } /*
        stage ('terra-plan') {
            steps {
                withCredentials([string(credentialsId: 'Terraform-Azure-LocalAdmin-Password', variable: 'ADMIN_PASS')]) {
                    bat "\"%TERRAFORM_PATH%\\terraform\" plan -var \"vm_admin_password=%ADMIN_PASS%\""
                }
            }
        }  
        stage ('terra-apply') {
            steps {
                withCredentials([string(credentialsId: 'Terraform-Azure-LocalAdmin-Password', variable: 'ADMIN_PASS')]) {
                    bat "\"%TERRAFORM_PATH%\\terraform\" apply -var \"vm_admin_password=%ADMIN_PASS%\" -auto-approve"
                } 
            } 
        } */
    }
}


def getTerraformPath () {
    def HomeDir = tool name: 'Terraform-12', type: 'org.jenkinsci.plugins.terraform.TerraformInstallation'
    return HomeDir
}

def createTerraformStorageContainer () {
    withCredentials([string(credentialsId: 'Terraform-Azure-StorageAccount-Connection', variable: 'ACCOUNT_CONNECTION')]) {
        bat "az storage container create -n %ARM_STATE_CONTAINER_NAME% --connection-string \"%ACCOUNT_CONNECTION%\""
    }
}