class profile::corrective_change_example {
  #Use this profile with the secrets_example profile
  cron { 'do bad things to file permissions':
    command => '/bin/chmod 777 /root/.my_secret_file',
    user    => root,
    minute  => ['*/5'],
  }
}
