class profile::windows::join_domain(
  $domain_name          = hiera('profile::windows::join_domain::domain_name'),
  $domain_join_username = hiera('profile::windows::join_domain::domain_join_username'),
  $domain_join_password = hiera('profile::windows::join_domain::domain_join_password'),
  $domain_join_ou       = hiera('profile::windows::join_domain::domain_join_ou'),
) {

  dsc_xcomputer { "Join ${domain_name} domain":
    dsc_name       => $facts['hostname'],
    dsc_domainname => $domain_name,
    dsc_joinou     => $domain_join_ou,
    dsc_credential => {
      'user'     => $domain_join_username,
      'password' => $domain_join_password
    },
  }

  reboot { 'afterdomainjoin':
    apply     => finished,
    subscribe =>  Dsc_xcomputer["Join ${domain_name} domain"],
  }
}
