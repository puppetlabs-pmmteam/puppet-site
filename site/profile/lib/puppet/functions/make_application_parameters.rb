# Generate app component titles when missing
#
# @return [Hash] Application instance parameters
Puppet::Functions.create_function(:make_application_parameters) do
  def make_application_parameters(parameters)
    parameters['parameters'] = Hash.new unless parameters.has_key?('parameters')
    components = parameters['components']
    nodes_hash = Hash.new

    components.each do |component, nodes|
      [*component].each do |comp|
        nodes.each do |node_name|
          node_resource_format = "Node[#{node_name}]"
          unless nodes_hash.has_key? node_resource_format
            nodes_hash[node_resource_format] = Array.new
          end

          nodes_hash[node_resource_format] << "#{comp}[#{node_name}]"
        end
      end
    end

    {'nodes' => nodes_hash}.merge(parameters['parameters'])
  end
end
