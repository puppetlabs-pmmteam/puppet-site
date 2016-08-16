Puppet::Type.newtype :vinfrastructure, :is_capability => true do
  newparam :name
  newparam :memory
  newparam :cpus
  newparam :template
end
