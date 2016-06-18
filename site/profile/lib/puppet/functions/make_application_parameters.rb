# Generate app component titles when missing
#
# @return [Hash] Application instance parameters
Puppet::Functions.create_function(:make_application_parameters) do
  def make_application_parameters(parameters)
    components = parameters['components']
    nodes_hash = Hash.new

    components.each do |component, nodes|
      [component].each do |comp|
        nodes.each do |node|
          unless nodes_hash.hash_key? node
            nodes_hash[node] = Array.new
          end

          nodes_hash[node] << "#{comp}[#{node}]"
        end
      end
    end

    {'nodes' => nodes_hash}.merge(parameters['parameters'])
  end
end
