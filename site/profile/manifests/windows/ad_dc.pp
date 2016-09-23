# Need to use the 'hiera()' call so it merge mutli level hierarchy
class profile::windows::ad_dc(
  $domain_name             = hiera('profile::windows::ad_dc::domain_name'),
  $domain_admin_username   = hiera('profile::windows::ad_dc::domain_admin_username'),
  $domain_admin_password   = hiera('profile::windows::ad_dc::domain_admin_password'),
  $safemode_admin_username = hiera('profile::windows::ad_dc::safemode_admin_username'),
  $safemode_admin_password = hiera('profile::windows::ad_dc::safemode_admin_password'),
  $is_first_dc             = hiera('profile::windows::ad_dc::is_first_dc'),
  $first_dc_dns            = hiera('profile::windows::ad_dc::first_dc_dns'),
) {

  windows_ad::install_dc { $domain_name:
    domain_name             => $domain_name,
    domain_admin_username   => $domain_admin_username,
    domain_admin_password   => $domain_admin_password,
    safemode_admin_username => $safemode_admin_username,
    safemode_admin_password => $safemode_admin_password,
    is_first_dc             => $is_first_dc,
    first_dc_dns            => $first_dc_dns,
  }
}
