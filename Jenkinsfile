def registry = 'https://awssoorinje.jfrog.io/'
def imageName = 'awssoorinje.jfrog.io/valaxy-docker-local/ttrend'
def version = '2.1.2'

pipeline {
    agent {
        label "maven"
    }
    environment {
        PATH = "/opt/apache-maven-3.9.3/bin:$PATH"
    }

    stages {
        // Build Stage
        stage('build') {
            steps {
                echo "build started alas !!"
                sh "mvn clean deploy -Dmaven.test.skip=true"
                echo "build completed alas !!"
            }
        }

        // Test Stage
        stage("test") {
            steps {
                echo "unit test started by Mr.Nazir devops engineer"
                sh 'mvn surefire-report:report'
                echo "unit test completed alas!!"
            }
        }

        // SonarQube Analysis Stage
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

        // Quality Gate Test Stage
        stage('quality-gate-test') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "pipeline aborted due to qg failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        // Jar Publish Stage
        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    def server = Artifactory.newServer(url: registry + "/artifactory", credentialsId: "awssoorinje")
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
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

        // Docker Build Stage
        stage("Docker Build") {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build(imageName + ":" + version)
                    echo '<--------------- Docker Build Ends --------------->'
                }
            }
        }

        // Docker Publish Stage
        stage("Docker Publish") {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry(registry, 'awssoorinje') {
                        app.push()
                    }
                    echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }
    }
}
