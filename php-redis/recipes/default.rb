remote_file "#{Chef::Config[:file_cache_path]}/phpredis.tar.gz" do
  source node['php_redis']['url']
  not_if 'php -m | grep redis'
end

bash 'make & install phpredis' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  apt-get install php5.6-dev -y
  tar zxf phpredis.tar.gz
  cd phpredis-master
  phpize
  ./configure
  make && make install
  EOF
  not_if 'php -m | grep redis'
end

file "#{node['php']['extensions']['config_dir']}/redis.ini" do
  owner 'root'
  group 'root'
  mode '0644'
  content 'extension=redis.so'
  not_if 'php -m | grep redis'
end

file "#{node['php']['cli_dir']}/redis.ini" do
  owner 'root'
  group 'root'
  mode '0644'
  content 'extension=redis.so'
  not_if 'php -m | grep redis'
end

file "#{node['php']['fpm_dir']}/redis.ini" do
  owner 'root'
  group 'root'
  mode '0644'
  content 'extension=redis.so'
  not_if 'php -m | grep redis'
end
