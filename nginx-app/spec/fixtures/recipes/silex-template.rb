template '/tmp/config.conf' do
  cookbook 'nginx-app'
  source 'silex.conf.erb'
  mode node['testdata']['mode']
  owner node['testdata']['owner']
  group node['testdata']['group']
  helpers(EasyBib::Helpers)
  variables(
    :domain_name => node['testdata']['domain_name'],
    :doc_root => node['testdata']['doc_root'],
    :access_log => node['testdata']['access_log'],
    :default_router => node['testdata']['default_router'],
    :php_upstream => node['testdata']['pools'],
    :upstream_name => 'foo',
    :routes_enabled => node['testdata']['routes_enabled'],
    :routes_denied => node['testdata']['routes_denied'],
    :htpasswd => node['testdata']['htpasswd']
  )
end
