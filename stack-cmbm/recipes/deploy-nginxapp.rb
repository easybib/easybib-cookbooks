include_recipe 'nginx-app::server'
include_recipe 'supervisor'

user = if is_aws
         node.fetch('nginx-app', {}).fetch('user', 'www-data')
       else
         'vagrant'
       end

applications = if is_aws
                 node['deploy']
               else
                 node['vagrant']['applications']
               end

applications.each do |app_name, app_config|

  case app_name
  when 'cm'
    next unless allow_deploy(app_name, 'cm', 'nginxapp_cm')
  when 'bm'
    next unless allow_deploy(app_name, 'bm', 'nginxapp_bm')
  else
    Chef::Log.info("stack-cmbm::deploy-nginxapp - #{app_name} skipped.")
    next
  end

  template = 'default-web-nginx.conf.erb'

  app_data           = ::EasyBib::Config.get_appdata(node, app_name)
  domain_name        = app_data['domains']
  doc_root_location  = app_data['doc_root_dir']
  app_dir            = app_data['app_dir']
  app_ruby           = node.fetch(app_name, {}).fetch('env', {}).fetch('ruby', {}).fetch('version', '')
  gem_home           = node.fetch(app_name, {}).fetch('env', {}).fetch('gem', {}).fetch('home', '')
  rundir             = node['stack-cmbm']['puma']['rundir']

  next if app_name == 'ssl'

  Chef::Log.info("ies_rbenv_deploy: deploying #{app_ruby} for #{app_name} (GEM_HOME=#{gem_home})")
  ies_rbenv_deploy 'deploy ruby' do
    rbenv_users [user]
    rubies [app_ruby]
    gems ['bundler']
  end

  if is_aws
    easybib_deploy app_name do
      deploy_data app_config
      app app_name
    end
  else
    easybib_envconfig app_name
  end

  easybib_nginx app_name do
    cookbook 'stack-cmbm'
    config_template template
    deploy_dir doc_root_location
    domain_name domain_name
    app_dir app_dir
    notifies :reload, 'service[nginx]', :delayed
  end

  directory rundir do
    owner user
    group user
    mode '0755'
  end

  supervisor_service "#{app_name}_supervisor" do
    action [:enable, :restart]
    autostart true
    command "bash -l -c 'cd #{app_dir}; source .deploy_configuration.sh; #{gem_home}/bin/puma -C config/puma.rb config.ru'"
    numprocs 1
    numprocs_start 0
    priority 999
    autostart true
    autorestart true
    startsecs 0
    startretries 3
    stopsignal 'TERM'
    stopwaitsecs 10
    user user
    redirect_stderr false
    stdout_logfile 'syslog'
    stdout_logfile_maxbytes '50MB'
    stdout_logfile_backups 10
    stdout_capture_maxbytes '0'
    stdout_events_enabled false
    stderr_logfile 'syslog'
    stderr_logfile_maxbytes '50MB'
    stderr_logfile_backups 10
    stderr_capture_maxbytes '0'
    stderr_events_enabled false
    serverurl 'AUTO'
  end
end
