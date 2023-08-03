pipeline {
    agent {
        label "maven"
    }

    stages {
        stage('clone-code') {
            steps {
               git branch: 'main', url: 'https://github.com/soorinjeaws/tweet-trend-new.git'
            }
        }
    }
}

