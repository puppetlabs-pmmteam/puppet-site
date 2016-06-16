def merge(from, to) {
  sh('git checkout ' + to)
  sh('git merge ' + from + ' --ff-only')
}

def promote(Map parameters = [:]) {
  String from = parameters.from
  String to = parameters.to
  String repo = parameters.repo

  merge(from, to)

  withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'github-ccaum-userpass', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
    sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}@' + repo + ' ' + to)
  }
}

node {
    git branch: 'dev', credentialsId: 'github-ccaum-userpass', url: 'https://github.com/puppetlabs-pmmteam/puppet-site'

    stage 'Lint and unit tests'
    withEnv(['PATH=/usr/local/bin:$PATH']) {
      sh 'bundle install'
      sh 'bundle exec rspec spec/'
    }

    stage 'Deploy to dev'
    // These methods are provided by the Pipeline: Puppet Enterprise plugin
    // The `puppetCode` method instructs PE to ensure the latest dev environment code 
    // is pushed to the Puppet server
    // The `puppetJob' method instructs PE to run Puppet across the entire dev 
    // environment.
    puppetCode environment: 'dev', credentialsId: 'pe-access-token'
    puppetJob  environment: 'dev', credentialsId: 'pe-access-token'

    stage 'Promote to staging'
    input "Ready to deploy to staging?"
    promote from: 'dev', to: 'staging', repo: 'github.com/puppetlabs-pmmteam/puppet-site'
    
    stage 'Deploy to staging'
    puppetCode environment: 'staging', credentialsId: 'pe-access-token'
    puppetJob  environment: 'staging', credentialsId: 'pe-access-token'

    stage 'Staging acceptance tests'
    // Run acceptance tests here to make sure no applications are broken

    stage 'Promote to production'
    promote from: 'staging', to: 'production', repo: 'github.com/puppetlabs-pmmteam/puppet-site'

    stage 'Noop production run'
    puppetJob  environment: 'production', noop: true, credentialsId: 'pe-access-token'

    stage 'Deploy to production'
    input "Ready to deploy to production?"
    puppetCode environment: 'production', credentialsId: 'pe-access-token'
    puppetJob  environment: 'production', concurrency: 40, credentialsId: 'pe-access-token'
}
