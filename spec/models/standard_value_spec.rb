# == Schema Information
#
# Table name: standard_values
#
#  id         :integer          not null, primary key
#  name       :text
#  set        :integer
#  n2o        :float
#  co2        :float
#  ch4        :float
#  valid_from :datetime
#  valid_to   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe StandardValue, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
