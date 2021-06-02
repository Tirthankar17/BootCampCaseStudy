node{
    //preparing environment
    def gitURL
    def maven
    def mavenCMD
    
    stage('Preparing environment'){
        gitURL="https://github.com/Tirthankar17/DevOpsBootCampCaseStudy.git"
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
    stage('Build Test and Package'){
        echo "Building the code"
        sh "${mavenCMD} clean package"
    }
    stage('Building docker Image'){
        docker.withTool('Docker'){
            docker.withRegistry('https://registry.hub.docker.com/','dockerCred'){
            echo "Successfully logged in Docker Hub"
            def customImage = docker.build('tirthankar17/bootcamp-case-study:1.0')
            echo "Image built successfully"
            customImage.push()
            }
        }
    }
    stage('Deploying app to slave node via Ansible'){
        ansiblePlaybook become: true, credentialsId: 'ansiblejenkins', disableHostKeyChecking: true, installation: 'ansible', inventory: '/etc/ansible/hosts', playbook: 'deployapp.yml'
        echo "App deployed successfully on hosts"
    }
            

}
