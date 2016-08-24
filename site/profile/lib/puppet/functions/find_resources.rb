Puppet::Functions.create_function(:find_resources) do
  def find_resources(type)
    type = String(type).capitalize
    scope.compiler.catalog.resources.select { |r| r.type == type }
  end
end
