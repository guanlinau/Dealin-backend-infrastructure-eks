#!/user/bin/env/groovy
def gv
pipeline{
    agent any

    parameters {
        booleanParam(name:'CreateResources', defaultValue:false, description: 'Select when you want to create resources, such as eks, vpc, subnets, nat gateway, nodegroup, etc.')
        booleanParam(name:'DestroyResources', defaultValue:false, description: 'Select when you want to destroy resources!')
    }
	environment {
		AWS_CREDENTIALS = "aws_credentials"
        AWS_REGION = "ap-southeast-2"
        APPLY = "apply"
        DESTROY = "destroy"
	}
    
    stages{
        stage ("Init load groovy") {
            steps{
                ansiColor('vga'){
                    script{
                        gv=load "script.groovy"
                    }
                    
                }
            }
        }
        stage("Terraform init"){
            steps{
				ansiColor('vga'){
					withAWS(credentials: "$AWS_CREDENTIALS", region: "$AWS_REGION") {
							sh "terraform  init"
					}
				}
            }
        }
        stage("Terraform validate"){
            steps{
                ansiColor('vga'){
                    withAWS(credentials: "$AWS_CREDENTIALS", region: "$AWS_REGION") {
                        sh "terraform validate"
                    }
                }
            }
        }
        stage("Terraform plan"){
            steps{
                ansiColor('vga'){
                    withAWS(credentials: "$AWS_CREDENTIALS", region: "$AWS_REGION") {
                        sh "terraform  plan"
                    }
                }
            }
        }
        stage('Terraform apply'){
            when { 
                expression{ return params.CreateResources }
                expression{ return !params.DestroyResources}
                expression{
                    BRANCH_NAME == "main"                 
                }
            }
            steps{
				ansiColor('vga'){
					withAWS(credentials: "$AWS_CREDENTIALS", region: "$AWS_REGION") {
                        script{
                            gv.terraform(env.APPLY)
                        }
					    
					}
				}
            }
            post{
                always{
                    script{
                        echo "backup the vertical pod autoscaler repo"
                        sh"cd ./modules/VPA_INSTALL && ls -al"
                        sh 'cp -r ./modules/VPA_INSTALL/autoscaler /tmp/autoscaler_backup || true'
                    }
                }
            }
        }
        stage('Terraform destroy'){
            when { 
                expression{ return !params.CreateResources }
                expression{ return params.DestroyResources }
                expression{
                    BRANCH_NAME == "main"
                }
            }
            steps{
				ansiColor('vga'){
					withAWS(credentials: "$AWS_CREDENTIALS", region: "$AWS_REGION") {
                        script{
                            echo "copy the vertical pod repo back to current workspace"
                            sh 'mkdir -p ./modules/VPA_INSTALL/ && cp -r /tmp/autoscaler_backup ./modules/VPA_INSTALL/autoscaler || true'
                            gv.terraform(env.DESTROY)
                        }					
					}
				}
            }
        }
    }

	post {
        failure {
            echo "Terraform pipeline execution failed!"
        }
        success {
            echo "Terraform pipeline execution succeeded!"
        }
		always {
			script {
                try{
                    cleanWs()
                }catch(Exception e) {
                    echo "Error: ${e}"
                    echo "clean failed!"
                }
            }
		}
	}	
}