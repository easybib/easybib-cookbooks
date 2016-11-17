node['deploy'].each do |application, deploy|

  Chef::Log.info("deploy::research-solr - app: #{application}")
  Chef::Log.info("Deploying as user: #{deploy['user']} and #{deploy['group']}")

  next unless allow_deploy(application, 'research_solr', 'easybib_solr_server')

  Chef::Log.info('deploy::research-solr - Deployment started.')

  easybib_deploy application do
    deploy_data deploy
  end

  execute "copy config from git to solr basedir - #{application}" do
    cwd     node['apache_solr']['base_dir']
    command "cp -R #{node['apache_solr']['config_source_dir']}/* #{node['apache_solr']['base_dir']}/solr/"
    only_if do
      application == 'research_solr'
    end
    notifies :start, 'service[apache-solr]'
  end
end
