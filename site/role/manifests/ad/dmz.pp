class role::ad::dmz {

  include profile::windows::baseline
  include profile::windows::ad_dc
  include profile::windows::ad_dc_baseline
  include profile::windows::ad_dc_dmz

}
