require 'spec_helper'

describe Lid do
  it {should have_many :incubations}

  let(:lid) {Lid.new}

  it 'should have a surface area' do
    lid.respond_to?(:surface_area).should be_true
  end
end

# == Schema Information
#
# Table name: lids
#
#  id           :integer          not null, primary key
#  surface_area :float
#  name         :string(255)
#  volume       :float
#  height       :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

