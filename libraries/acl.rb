#
# Author:: Malte Swart (<chef@malteswart.de>)
# Cookbook Name:: openldap
#
# Copyright 2013, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef::Node
  def generate_openldap_acls_from_attributes
    self['openldap']['slapd_acls'].sort.inject([]) do |acl, (priority, aclMesh)|
      next acl if aclMesh.nil? # skipping because entry was removed
      # build what string
      what = [ 'to' ]
      unless aclMesh['dn'].nil?
        what << unless aclMesh['dntype'].nil?
          "dn=\"#{aclMesh['dn']}\""
        else
          "dn.#{aclMesh['dntype']}=\"#{aclMesh['dn']}\""
        end
      end
      unless aclMesh['filter'].nil?
        what << "filter=#{aclMesh['filter']}"
      end
      unless aclMesh['attrs'].nil?
        what << "attrs=#{aclMesh['attrs']}"
      end
      if what.size == 1
        what << '*'
      end
      accessLines = generate_openldap_acls_access_lines aclMesh['access']
      acl << [ what.join(' '), accessLines ]
    end
  end

  def generate_openldap_acls_access_lines(accessMesh)
    return [ "by * #{accessMesh}" ] if accessMesh.kind_of? String
    accessMesh.sort.inject([]) do |accessLines, (priority, accessEntry)|
      if accessEntry.kind_of? String # shortcut for by * <action>
        next accessLines << "by * #{accessEntry}"
      end
      # map all test=>testvalue
      accessLine = accessEntry.keys.inject(['by']) do |lines, key|
        next lines if %w{action control}.include? key.to_s
        lines << if accessEntry[key] == true # speci group like self, users
          key
        else
          "#{key}=\"#{accessEntry[key]}\""
        end
      end
      # add action
      accessLine << accessEntry['action']
      # add control key words
      unless accessEntry['control'].nil?
        accessLine << accessEntry['control']
      end
      accessLines << accessLine.join(' ')
    end
  end
end
