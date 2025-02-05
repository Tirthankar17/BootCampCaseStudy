try{
node{
    //preparing environment
    def gitURL
    def maven
    def mavenCMD
    
    stage('Preparing environment'){
        gitURL="https://github.com/Tirthankar17/BootCampCaseStudy.git"
        maven = tool name: 'Maven 3.8.1', type: 'maven'
        mavenCMD = "${maven}/bin/mvn"
    }
    stage('Code checkout from Git'){
        echo "Checking out the code"
        git "${gitURL}"
    }
    stage('Sonar Check'){
        withSonarQubeEnv('sonarqubeserver'){
            sh "${mavenCMD} clean package sonar:sonar"
        }
    }
    stage('AppScan Test'){
        appscan application: 'd057c057-af65-4fd0-a802-04e075efd31a', credentials: 'AppScanCred', name: 'AppScanTest', scanner: static_analyzer(hasOptions: false, target: "${WORKSPACE}"), type: 'Static Analyzer'
    }
    stage('Build and Package'){
        echo "Building the code"
        sh "${mavenCMD} clean test package"
        
    }
    stage('Publish HTML Report'){
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: "${WORKSPACE}", reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: ''])
    }
    stage('Building docker Image'){
        docker.withTool('Docker'){
            docker.withRegistry('https://registry.hub.docker.com/','dockerCred'){
            echo "Successfully logged in Docker Hub"
            def customImage = docker.build('tirthankar17/bootcamp-case-study:latest')
            echo "Image built successfully"
            customImage.push()
            }
        }
    }
    stage('Deploying app to slave node via Ansible'){
        ansiblePlaybook become: true, credentialsId: 'ansiblejenkins', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'deployapp.yml'
        echo "App deployed successfully on hosts"
        //sending mail after successful deployment
        mail body: "Code build ${BUILD_NUMBER} has completed successfully and deployed to host.", subject: "Build Report ${BUILD_NUMBER}" , to: 'guptatirthankar@gmail.com'
        currentBuild.result="SUCCESS"
    }
    stage('Clean up'){
            echo "Cleaning up the Workspace"
            cleanWs()
    }
            

}
}
catch(Exception err){
    echo "Exception occured in built, sending error notification..."
    currentBuild.result="FAILURE"
    mail body: "Build has failed with ${err}", subject: 'Build Report', to: 'guptatirthankar@gmail.com'
}
finally {
    if (currentBuild.result=="FAILURE") {
        echo "Code build number ${BUILD_NUMBER} has failed."
    }
    else if (currentBuild.result!= "ABORTED"){
        echo "Code build number ${BUILD_NUMBER} has completed successfully."
    }  
}
