class profile::cis_benchmarks {
  if $::environment == 'cis_benchmarks' {
    if $::operatingsystem == 'CentOS' {
      if $::operatingsystemmajrelease == 7 {
        include cis_rhel7
      }
    }
  }
}
