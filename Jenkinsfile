pipeline {
  agent any
  stages {
    stage('检出') {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: GIT_BUILD_REF]],
          userRemoteConfigs: [[
            url: GIT_REPO_URL,
            credentialsId: CREDENTIALS_ID
          ]]])
        }
      }
      stage('准备环境') {
        parallel {
          stage('准备配置') {
            steps {
              sh 'touch ~/.ssh/config'
              sh 'echo "Host heroku.com" >> ~/.ssh/config'
              sh 'echo "    HostName heroku.com" >> ~/.ssh/config'
              sh 'echo "    User git" >> ~/.ssh/config'
              sh 'echo "    IdentityFile ~/.ssh/key" >> ~/.ssh/config'
              sh 'echo "    HostKeyAlgorithms +ssh-rsa" >> ~/.ssh/config'
              sh 'echo "    PubkeyAcceptedKeyTypes +ssh-rsa" >> ~/.ssh/config'
            }
          }
          stage('准备 git 配置') {
            steps {
              sh 'git config --global user.email "${EMAIL}"'
              sh 'git config --global user.name "${NAME}"'
              sh 'git remote add heroku ${DEPLOY_REPO} || true'
            }
          }
        }
      }
      stage('部署到Heroku') {
        steps {
          withCredentials([
            sshUserPrivateKey(credentialsId: "$PRIVATE_KEY",
            keyFileVariable: 'SSH_PRIVATE_KEY_PATH')]) {
              sh "cat $SSH_PRIVATE_KEY_PATH > ~/.ssh/key && chmod 600 ~/.ssh/key"
              sh 'git push heroku HEAD:master'
            }

          }
        }
      }
    }