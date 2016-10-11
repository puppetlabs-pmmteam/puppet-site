class profile::secret_example (
  Sensitive[String] $secret_content,
) {

  file { '/root/.my_secret_file':
    owner   => root,
    group   => root,
    mode    => 600,
    content => $secret_content,
  }

  cron { 'destroy secret file':
    command => "rm -rf /root/.my_secret_file",
    user    => 'root',
    minute  => ['*/5'],
  }
}
