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

require_dependency 'redmine/access_control'

module OpenProject::GlobalRoles::Patches
  module PermissionPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable

        alias_method_chain :initialize, :global_option
      end
    end

    module InstanceMethods
      def initialize_with_global_option(name, hash, options)
        @global = options[:global] || false
        initialize_without_global_option(name, hash, options)
      end

      def global?
        @global || global_require
      end

      def global=(bool)
        @global = bool
      end

      private

      def global_require
        @require && @require == :global
      end
    end
  end
end

Redmine::AccessControl::Permission.send(:include, OpenProject::GlobalRoles::Patches::PermissionPatch)
