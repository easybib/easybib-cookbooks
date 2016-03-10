include_recipe 'stack-easybib::role-phpapp'
include_recipe 'supervisor'

if is_aws
  include_recipe 'easybib-deploy::ssl-certificates'
  include_recipe 'stack-academy::deploy'
else
  include_recipe 'nginx-app::vagrant'
end
