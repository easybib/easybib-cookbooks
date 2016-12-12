actions :create, :delete

default_action :create

attribute :app, :kind_of => String, :name_attribute => true
attribute :deploy_data, :default => {}
attribute :app_dir, :kind_of => String, :default => ''
attribute :supervisor_file, :kind_of => String, :default => ''
attribute :user, :kind_of => String, :default => ''
attribute :supervisor_role, :kind_of => String, :default => nil
attribute :instance_roles, :default => []
