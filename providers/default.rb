include Chef::Mixin::ShellOut


action :create do
  do_action
  new_resource.updated_by_last_action(true)
end

action :update do
  do_action
  new_resource.updated_by_last_action(true)
end

action :delete do
  execute "delete_command" do
    command "#{ldap_delete_command} #{@new_resource.name}"
    action :nothing
  end
  template "#{node['openldap']['config_dir']}/#{@new_resource.name}.ldif" do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end

protected
def do_action
  directory node['openldap']['config_dir']
  
  Chef::Log.info("Processing #{@new_resource.resource_name} #{@new_resource.name} action #{@new_resource.action}")
  
  if @new_resource.resource_name == :openldap_node
    ldap_command = "ldapadd -D \"#{node['openldap']['rootdn']}\" -w#{node['openldap']['rootpw']} -f "
    ldap_delete_command = "ldapdelete -D \"#{node['openldap']['rootdn']}\" -w#{node['openldap']['rootpw']} "
  elsif @new_resource.resource_name == :openldap_config
    ldap_command = "ldapadd -Y EXTERNAL -H ldapi:/// -f "
    ldap_delete_command = "ldapdelete -Y EXTERNAL -H ldapi:/// "
  end

  execute "create_command" do
    command "#{ldap_command} #{node['openldap']['config_dir']}/#{new_resource.name}.ldif"
#    ignore_failure true
    action :nothing
  end
  execute "delete_command" do
    command "#{ldap_delete_command} #{new_resource.name}"
    ignore_failure true
    action :nothing
  end
  #occasionally the action of the resource is a array, if not default and a symbol if default. Thats odd.
  
  create =  if new_resource.action.kind_of?(Array)
              new_resource.action.include?(:create)
            else
              new_resource.action == :create
            end
  update =  if new_resource.action.kind_of?(Array)
              new_resource.action.include?(:update)
            else
              new_resource.action == :update
            end
  #create template from given template or autogenerate by given attributes
  template "#{new_resource.name}_template" do
    path "#{node['openldap']['config_dir']}/#{new_resource.name}.ldif"
    #Chef::Log.info(new_resource)
    if new_resource.template
      source new_resource.template
    else
      cookbook "openldap"
      variables ({
          :name => new_resource.name,
          :attributes => new_resource.attributes
        })
      if create
        source "ldap=add.ldif.erb"
      elsif update
        source "ldap=modify.ldif.erb"
      end
    end
    
    if create
      notifies :run, "execute[delete_command]", :immediately
    end
    notifies :run, "execute[create_command]", :immediately
  end
  
end
