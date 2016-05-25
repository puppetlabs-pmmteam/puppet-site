module Puppet::Parser::Functions
  newfunction(:generate_host_db_grants, :type => :rvalue) do |args|
    user = args[0]
    hosts = Array(args[1])
    privileges = Array(args[2])
    table = if args[3]
              args[3]
            else
              '*.*'
            end


    grants_hash = Hash.new

    hosts.each do |host|
      grants_hash["#{user}@#{host}/#{table}"] = {
        'ensure' => 'present',
        'table' => table,
        'privileges' => privileges,
        'user' => "#{user}@#{host}",
        'require' => "Mysql_user[#{user}@#{host}]",
      }
    end

    grants_hash
  end
end
