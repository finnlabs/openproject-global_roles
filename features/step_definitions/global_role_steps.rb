#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2010-2013 the OpenProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

Given /^there is the global permission "(.+)?" of the module "(.+)?"$/ do |perm_name, perm_module|
  Redmine::AccessControl.map do |map|
    map.project_module perm_module.to_sym do |mod|
      mod.permission perm_name.to_sym, {:dont => :care}, {:project_module => perm_module.to_sym, :global => true}
    end
  end
end

Given /^the global permission "(.+)?" of the module "(.+)?" is defined$/ do |perm_name, perm_module|
  as_admin do
    permissions = Redmine::AccessControl.modules_permissions(perm_module)
    permissions.detect{|p| p.name == perm_name.to_sym && p.global?}.should_not be_nil
  end
end

Given /^there is a global [rR]ole "([^\"]*)"$/ do |name|
  FactoryGirl.create(:global_role, :name => name) unless GlobalRole.find_by_name(name)
end

Given /^the global [rR]ole "([^\"]*)" may have the following [rR]ights:$/ do |role, table|
  r = GlobalRole.find_by_name(role)
  raise "No such role was defined: #{role}" unless r
  as_admin do
    available_perms = Redmine::AccessControl.permissions.collect(&:name)
    r.permissions = []

    table.raw.each do |_perm|
      perm = _perm.first
      unless perm.blank?
        perm = perm.gsub(" ", "_").underscore.to_sym
        if available_perms.include?(:"#{perm}")
          r.permissions << perm
        end
      end
    end

    r.save!
  end
end

Given /^the [Uu]ser (.+) has the global role (.+)$/ do |user, role|
  user = User.find_by_login(user.gsub("\"", ""))
  role = GlobalRole.find_by_name(role.gsub("\"", ""))

  as_admin do
    FactoryGirl.create(:principal_role, :principal => user, :role => role)
  end
end

When /^I select the available global role (.+)$/ do |role|
  r = GlobalRole.find_by_name(role.gsub("\"", ""))
  raise "No such role was defined: #{role}" unless r
  steps %Q{
    When I check "principal_role_role_ids_#{r.id}"
  }
end

When /^I delete the assigned role (.+)$/ do |role|
  g = GlobalRole.find_by_name(role.gsub("\"", ""))
  raise "No such role was defined: #{role}" unless g
  raise "More than one or no principal has this role" if g.principal_roles.length != 1

  steps %Q{
    When I follow "Delete" within "#principal_role-#{g.principal_roles[0].id}"
  }
end
