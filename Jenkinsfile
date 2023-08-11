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
    }
}
