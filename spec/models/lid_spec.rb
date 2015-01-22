require 'rails_helper'

describe Lid do
  it { is_expected.to have_many :incubations }
  #TODO: does this only fail on sqlite?
  #it { is_expected.to validate_uniqueness_of(:name) }


  let(:lid) {Lid.new}

  it 'has a surface area' do
    expect(lid.respond_to?(:surface_area)).to be_truthy
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
