pipeline {
    agent {
        docker {
            image 'node:18.20-alpine'
            args '--network=host'
        }
    }
    environment {
    NEXUS_URL = 'http://localhost:8081'
}
environment {
    NPM_CONFIG_CACHE = "${WORKSPACE}/.npm"
}

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        APP_NAME = 'kijanikiosk-payments'
        NEXUS_URL = 'http://localhost:8081'
        NEXUS_REPO = 'npm-hosted'
        VERSION = "1.0.${BUILD_NUMBER}-${GIT_COMMIT.take(7)}"
    }

    stages {

        stage('Lint') {
            steps {
                sh 'npm install'
                sh 'echo "lint skipped" '
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Verify') {

            parallel {

                stage('Test') {
                    steps {
                        sh 'npm test'
                    }
                }

                stage('Security Audit') {
                    steps {
                        sh 'npm audit --audit-level=high'
                    }
                }
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'dist/**', fingerprint: true
            }
        }

        stage('Publish') {
    steps {
        withCredentials([
            usernamePassword(
                credentialsId: 'nexus-npm-creds',
                usernameVariable: 'NEXUS_USER',
                passwordVariable: 'NEXUS_PASS'
            )
        ]) {
export NPM_CONFIG_CACHE=/tmp/.npm
mkdir -p /tmp/.npm
            sh '''
            export NPM_CONFIG_CACHE=/tmp/.npm
            mkdir -p /tmp/.npm

            npm version $VERSION --no-git-tag-version

            cat > .npmrc <<EOF
registry=http://localhost:8081/repository/npm-hosted/
_auth=$(echo -n "$NEXUS_USER:$NEXUS_PASS" | base64)
email=ci@kijanikiosk.com
always-auth=true
EOF

            npm publish --registry=http://localhost:8081/repository/npm-hosted/

            rm -f .npmrc
            '''
        }
    }
}
    post {
    always {
        cleanWs()
    }

    success {
        echo 'Artifact published successfully'
    }

    failure {
        echo 'Pipeline failed'
    }

    changed {
        echo 'Pipeline status changed'
    }
}

        success {
            echo "Artifact published successfully"
            echo "${NEXUS_URL}/repository/${NEXUS_REPO}/${APP_NAME}"
        }

        failure {
            echo "Pipeline failed"
        }

        changed {
            echo "Pipeline status changed"
        }
    }
}