
def registry = "https://awssoorinje.jfrog.io/ui/admin/configuration/security/access_tokens"
pipeline {
    agent {
        label "maven"
    }
    environment {
        PATH = "/opt/apache-maven-3.9.3/bin:$PATH"
    }

    stages {
        stage('build') {
            steps {
               echo " build started alas !! "
               sh "mvn clean deploy -Dmaven.test.skip=true"
               echo "build completed alas !! "
            }
        }

        stage("test"){
            steps{
                echo " unit test started by Mr.Nazir devops engineer "
                sh 'mvn surefire-report:report' 
                echo "unit test completed alas!! "
            }
        }

        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'nasir-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('nasir-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage('quality-gate-test') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') { // Opening brace for the timeout body
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK'){
                            error "pipeline aborted due to qg failure: ${qg.status}"
                        }
                    } // Closing brace for the timeout body
                }
            }
        }

        
        stage("Jar Publish") {
          steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"awssoorinje"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }   


    }
}
