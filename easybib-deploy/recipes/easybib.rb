include_recipe 'php-fpm::service'

instance_roles = get_instance_roles
cluster_name   = get_cluster_name

node['deploy'].each do |application, deploy|

  Chef::Log.info("deploy::easybib - app: #{application}, role: #{instance_roles}")

  case application
  when 'easybib'
    nginxphpapp_allowed = allow_deploy(application, 'easybib', 'nginxphpapp')
    testapp_allowed     = allow_deploy(application, 'easybib', 'testapp')
    if !nginxphpapp_allowed && !testapp_allowed
      next
    end

  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')

  else
    Chef::Log.info("deploy::easybib - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info('deploy::easybib - Deployment started.')
  Chef::Log.info("deploy::easybib - Deploying as user: #{deploy['user']} and #{deploy['group']}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  service 'php-fpm' do
    action node['easybib_deploy']['php-fpm']['restart-action']
  end

end
