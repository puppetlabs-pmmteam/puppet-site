class role::pe_master {
  include ::profile::common
  include ::profile::pe_env
  include ::profile::firewall
  include ::profile::pe_master
}
