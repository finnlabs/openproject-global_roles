#-- copyright
# OpenProject Global Roles Plugin
#
# Copyright (C) 2010 - 2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#++

require_dependency 'users_controller'

module OpenProject::GlobalRoles::Patches
  module UsersControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do

        before_filter :add_global_roles, only: [:edit]
      end
    end

    module InstanceMethods
      private

      def add_global_roles
        @global_roles = GlobalRole.all
      end
    end
  end
end

UsersController.send(:include, OpenProject::GlobalRoles::Patches::UsersControllerPatch)
