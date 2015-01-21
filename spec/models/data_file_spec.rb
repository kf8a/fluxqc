# == Schema Information
#
# Table name: data_files
#
#  id         :integer          not null, primary key
#  run_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe DataFile, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
