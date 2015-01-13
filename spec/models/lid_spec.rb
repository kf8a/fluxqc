require 'spec_helper'

describe Lid do
  it { should have_many :incubations }
  #TODO: does this only fail on sqlite?
  #it { should validate_uniqueness_of(:name) }


  let(:lid) {Lid.new}

  it 'should have a surface area' do
    lid.respond_to?(:surface_area).should eq true
  end
end

# == Schema Information
#
# Table name: lids
#
#  id           :integer          not null, primary key
#  name         :string(1)
#  volume       :float
#  height       :float
#  surface_area :float
#
