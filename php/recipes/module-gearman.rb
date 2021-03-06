include_recipe 'php::dependencies-ppa'

apt_repository 'php-gearman' do
  uri          node['php-gearman']['package_uri']
  distribution node['php-gearman']['package_distro']
end

apt_repository 'pkg-gearman' do
  uri          node['pkg-gearman']['package_uri']
  distribution node['pkg-gearman']['package_distro']
end

php_ppa_package 'gearman' do
  package_prefix node['php']['ppa']['package_prefix']
end
