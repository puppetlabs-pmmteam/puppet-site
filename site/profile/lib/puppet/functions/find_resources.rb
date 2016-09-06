Puppet::Functions.create_function(:find_resources) do
  def find_resources(type)
    type = String(type)
    closure_scope.catalog.resources.select { |r| r.type == type }
  end
end
