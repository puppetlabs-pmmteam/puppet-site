require 'json'
require 'net/http'

module_metadata = JSON::parse(IO.read("/etc/puppet/modules/profile/metadata.json"))

module_metadata['dependencies'].each do |dependency|
  name = dependency['name']
  version_string = dependency.has_key?('version_requirement') ? "--version  #{dependency['version_requirement']}" : String.new
  `puppet module install #{name} #{version_string}`
end
