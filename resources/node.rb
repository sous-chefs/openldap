actions :update, :create, :delete

attribute :name, :kind_of => String, :name_attribute => true
attribute :template, :kind_of => String
attribute :attributes, :kind_of => Hash

default_action :create


def initialize(name, run_context=nil)
  super
  set_platform_default_providers
end

private
def set_platform_default_providers
  Chef::Platform.set(
    :platform => :ubuntu,
    :resource => :openldap_node,
    :provider => Chef::Provider::Openldap
  )
end
