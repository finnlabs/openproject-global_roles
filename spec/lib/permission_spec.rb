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

require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Redmine::AccessControl::Permission do
  describe "WHEN setting global permission" do
    describe "creating with", :new do
      before {@permission = Redmine::AccessControl::Permission.new(:perm, {:cont => [:action]}, {:global => true})}
      describe :global? do
        it {@permission.global?.should be_true}
      end
    end
  end

  describe "setting non_global" do
    describe "creating with", :new do
      before {@permission = Redmine::AccessControl::Permission.new :perm, {:cont => [:action]}, {:global => false}}

      describe :global? do
        it {@permission.global?.should be_false}
      end
    end

    describe "creating with", :new do
      before {@permission = Redmine::AccessControl::Permission.new :perm, {:cont => [:action]}, {}}

      describe :global? do
        it {@permission.global?.should be_false}
      end
    end
  end
end
