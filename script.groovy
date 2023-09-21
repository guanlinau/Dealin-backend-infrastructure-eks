#!/usr/bin/env groovy
def terraform(String ACTION) {
    def maxAttempts =2
    for (int attempt = 1; attempt <=maxAttempts; attempt++){
        try{
            // conduct terraform action!
            sh "terraform ${ACTION} -auto-approve"
            // break if succeed!
            break
        }catch(Exception e){
            if(attempt==maxAttempts){
                throw e
            }
            echo "Terraform ${ACTION} failed on attempt ${attempt}, retrying or fixing issues..."
        }
    }
}

return this;