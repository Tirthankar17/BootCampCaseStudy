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
        //withSonarQubeEnv('sonarqubeserver'){
            //sh "${mavenCMD} sonar:sonar"
        //}
    }
    stage('AppScan Test'){
        //appscan application: '2f0476f4-f66c-464f-be87-25759eb32216', credentials: 'AppScanCred', name: 'AppScanTest', scanner: static_analyzer(hasOptions: false, target: "${WORKSPACE}"), type: 'Static Analyzer'
    }
    stage('Build and Package'){
        echo "Building the code"
        sh "${mavenCMD} clean test package"
        
    }
    stage('Publish HTML Report'){
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: ''])
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
    }
    stage('Clean up'){
            echo "Cleaning up the Workspace"
            cleanWs()
    }
            

}
}
catch(Exception err){
    echo "Exception occured..."
    currentBuild.result="FAILURE"
    mail body: 'Build has failed', subject: 'Build Report', to: 'guptatirthankar@gmail.com'
}
finally {
    (currentBuild.result!= "ABORTED") && node("master") {
        echo "finally gets executed and end an email notification for every build"
        mail body: 'Code build has completed successfully and deployed to hosts', subject: 'Build Report', to: 'guptatirthankar@gmail.com'
    }
    
}
