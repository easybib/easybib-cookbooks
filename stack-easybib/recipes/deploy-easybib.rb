node['deploy'].each do |application, deploy|
  case application
  when 'easybib'
    next unless allow_deploy(application, 'easybib', 'nginxphpapp')

  else
    Chef::Log.info("stack-easybib::deploy-easybib - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  # clean up old config before migration
  file '/etc/nginx/sites-enabled/easybib.com.conf' do
    action :delete
    ignore_failure true
  end

  easybib_nginx application do
    cookbook 'stack-easybib'
    config_template 'easybib.com.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end
end
