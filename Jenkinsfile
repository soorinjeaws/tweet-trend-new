
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
           




        stage('SonarQube analysis') { // Moved inside the 'stages' block
            environment {
                scannerHome = tool 'nasir-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('nasir-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}

