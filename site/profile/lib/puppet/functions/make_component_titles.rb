# Generate app component titles when missing
#
# @return [Hash] Application instance parameters
Puppet::Functions.create_function(:make_component_titles) do
  def make_component_titles(parameters, name_prefix)
    global_component_count = 0
    return_hash = parameters

    parameters['nodes'].each do |node, components|
      components.each_with_index do |component|
        unless component.match /^[\w:]+\[.*\]$/
          return_hash['nodes'][node][index] = "#{component}[#{name_prefix}-#{global_component_count}]"
        end

        global_component_count += 1
      end
    end

    return_hash
  end
end
