pipeline {
  agent {
    label 'ruby'
  }
  environment {
    DISCORD_WEBHOOK = credentials('discord-webhook-url')
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main',
          credentialsId: 'github-ssh-auth',
          url: 'git@github.com:KTQA/ktqa-music-indexer.git'
      }
    }
    stage('Lint Ruby') {
      steps {
        echo 'Running Rubocop...'
        sh 'rubocop 2>&1 | tee rubocop.txt'
        echo 'Rubocop complete.'
      }
    }
    stage('Archive') {
      steps {
        echo 'Archiving Rubocop results for your reviewing pleasure...'
        archiveArtifacts artifacts: '*.txt', fingerprint: false
        echo 'Archived. It will be available in the Jenkins UI.'
      }
    }
  }
  post {
    always {
      discordSend description: "KTQA Music Indexer Code Analysis: ${currentBuild.currentResult}",
                    footer: "Click the link to view the results.",
                    link: env.BUILD_URL,
                    result: currentBuild.currentResult,
                    title: JOB_NAME, webhookURL: DISCORD_WEBHOOK
    }
  }
}