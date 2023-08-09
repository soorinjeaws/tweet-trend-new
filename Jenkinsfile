
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
               sh "mvn clean deploy"
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

