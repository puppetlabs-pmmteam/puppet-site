module Puppet::Parser::Functions
  newfunction(:generate_host_db_users, :type => :rvalue) do |args|
    user = args[0]
    hosts = Array(args[1])
    password = args[2]

    users_hash = Hash.new

    hosts.each do |host|
      users_hash["#{user}@#{host}"] = { 'ensure' => 'present', 'password_hash' => function_mysql_password([password]) }
    end

    users_hash
  end
end
