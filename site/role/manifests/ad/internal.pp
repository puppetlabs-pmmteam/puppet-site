class role::ad::internal {

  include profile::windows::baseline
  include profile::windows::ad_dc
  include profile::windows::ad_dc_baseline
  include profile::windows::ad_dc_internal
  include profile::windows::cloudshop_app_groups
}
