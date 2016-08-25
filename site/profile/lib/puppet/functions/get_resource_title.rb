Puppet::Functions.create_function(:get_resource_title) do
  def get_resource_title(resource)
    resource.title
  end
end
