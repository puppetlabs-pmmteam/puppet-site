class profile::jenkins {

  class { '::jenkins':
    configure_firewall => true,
  }

  #jenkins::job { "control-repo":
  #  ensure  => present,
  #  enabled => true,
  #  config  => epp('profile/jenkins_job_config.epp'),
  #}

  jenkins::plugin { 'workflow-puppet-enterprise':
    source => 'http://int-resources.ops.puppetlabs.net/carl/workflow-puppet-enterprise.hpi',
  }

  jenkins::plugin { 'copyartifact': }

  file {'/var/www/html/builds':
    ensure  => directory,
    owner   => $::jenkins::user,
    group   => $::jenkins::group,
    require => Class['jenkins'],
  }

}
