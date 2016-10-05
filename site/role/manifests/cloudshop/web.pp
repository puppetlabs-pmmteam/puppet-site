class role::cloudshop::web {
  
  include profile::windows::baseline
  include profile::windows::join_domain
  include profile::iis::baseline
  include profile::iis::cloudshop
}
