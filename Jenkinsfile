def merge(from, to) {
  sh('git checkout ' + to)
  sh('git merge ' + from + ' --ff-only')
}

def promote(Map parameters = [:]) {
  String from = parameters.from
  String to = parameters.to

  merge(from, to)

  sshagent(['control-repo-github']) {
    sh "git push origin " + to
  }
}

node {
    git branch: 'dev', credentialsId: 'control-repo-github', url: 'git@github.com:puppetlabs/pmm-puppet-site'

    stage 'Lint and unit tests'
    withEnv(['PATH=/usr/local/bin:$PATH']) {
      sh 'bundle install'
      sh 'bundle exec rspec spec/'
    }

    //Set the Jenkins credentials that hold our Puppet Enterprise RBAC token
    puppet.credentials 'pe-access-token'

    stage 'Deploy to dev'
    // These methods are provided by the Pipeline: Puppet Enterprise plugin
    // The `puppetCode` method instructs PE to ensure the latest dev environment code 
    // is pushed to the Puppet server
    // The `puppetJob' method instructs PE to run Puppet across the entire dev 
    // environment.
    puppet.codeDeploy 'dev'
    puppet.job 'dev'

    stage 'Promote to staging'
    input "Ready to deploy to staging?"
    promote from: 'dev', to: 'staging'
    
    stage 'Deploy to staging'
    puppet.codeDeploy 'staging'
    puppet.job 'staging'

    stage 'Staging acceptance tests'
    // Run acceptance tests here to make sure no applications are broken

    stage 'Promote to production'
    promote from: 'staging', to: 'production'
    puppet.codeDeploy 'production'

    stage 'Noop production run'
    puppet.job 'production', noop: true

    stage 'Deploy to production'
    input "Ready to deploy to production?"
    puppet.codeDeploy 'production'
    puppet.job 'production', concurrency: 40
}
