require 'rails_helper'

describe Standard do
  it {should belong_to :standard_curve}

  describe 'data output' do
    it 'includes a list of areas and ppms' do

    end
  end
end

# == Schema Information
#
# Table name: standards
#
#  id                :integer          not null, primary key
#  standard_curve_id :integer
#  compound_id       :integer
#  vial              :string(255)
#  ppm               :float
#  area              :float
#  excluded          :boolean
#  starting_time     :datetime
#  ending_time       :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  column            :integer
#  acquired_at       :datetime
#
