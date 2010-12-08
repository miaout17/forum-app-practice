# == Schema Information
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Category do
  pending "add some examples to (or delete) #{__FILE__}"
end
