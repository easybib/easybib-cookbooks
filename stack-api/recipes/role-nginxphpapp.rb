include_recipe 'ies::role-phpapp'

if is_aws
  include_recipe 'easybib-deploy::silex'
else
  include_recipe 'nginx-app::vagrant-silex'
end
