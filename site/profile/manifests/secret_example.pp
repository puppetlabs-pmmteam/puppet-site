class profile::secret_example (
  Sensitive[String] $secret_content = 'super secret',
) {

  file { '/root/.my_secret_file':
    owner   => root,
    group   => root,
    mode    => '0600',
    content => $secret_content,
  }
}
