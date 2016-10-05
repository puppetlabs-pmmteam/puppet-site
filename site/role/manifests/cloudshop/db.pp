class role::cloudshop::db {
  
  include profile::windows::baseline
  include profile::windows::join_domain
  include profile::mssql::baseline
  include profile::mssql::cloudshop

}
