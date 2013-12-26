#!/usr/bin/env ruby

require 'fog'
require 'colorize'

def done; puts "[Done]".colorize(:green); end

group_options = {
  :name => 'gitolite',
  :description => 'Allow access to gitolite running on port 2222'
}

server_options = {
  :image_id => 'ami-ad184ac4',
  :username => 'ubuntu',
  :private_key_path => '~/.ssh/id_rsa',
  :public_key_path => '~/.ssh/id_rsa.pub',
  :groups => ['default', 'gitolite'],
  :tags => { 'Name' => 'gitolite' }
}

unless Fog::Compute[:aws].security_groups.any? { |g| g.name == group_options[:name] }
  puts "#{"[Securing]".colorize(:cyan)} port 2222 for gitolite"
  gitolite_group = Fog::Compute[:aws].security_groups.create(group_options)
  gitolite_group.authorize_port_range(2222..2222)
  done
end

if Fog::Compute[:aws].servers.any? { |s| s.tags['Name'] == 'gitolite' }
  raise 'A gitolite instance already exists, aborting here.' 
end

puts "#{"[Booting]".colorize(:cyan)} an instance in AWS with options: #{server_options}..."
server = Fog::Compute[:aws].servers.bootstrap(server_options)
done

puts "#{"[Uploading]".colorize(:cyan)} resources for bootstrapping."
server.scp('bootstrap-docker.sh', '/tmp/bootstrap-docker.sh')
server.scp(File.expand_path(server_options[:public_key_path]), '/tmp/id_rsa.pub')
done

puts "#{"[Bootstrapping]".colorize(:cyan)}"
server.ssh('/bin/bash /tmp/bootstrap-docker.sh') do |output|
  puts output.first unless output.first == "\r\n"
end
done
