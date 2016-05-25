node {
    stage 'dev'
    puppetCode environment: 'dev', credentialsId: 'pe-access-token'
    puppetJob  environment: 'dev', credentialsId: 'pe-access-token'

    stage 'staging'
    puppetCode environment: 'staging', credentialsId: 'pe-access-token'
    puppetJob  environment: 'staging', credentialsId: 'pe-access-token'

    stage 'production'
    puppetCode environment: 'production', credentialsId: 'pe-access-token'
    puppetJob  environment: 'production', credentialsId: 'pe-access-token'

}
