# Retrieve the environment scope for the compiler
#
# @return [String] the name of the environment being compiled for
Puppet::Functions.create_function(:get_compiler_environment) do
  def get_compiler_environment
    String(closure_scope.environment)
  end
end
