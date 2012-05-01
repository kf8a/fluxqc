require 'spec_helper'

describe StandardCurve do
  it {should have_many :standards}
  it {should belong_to :run}
  it {should belong_to :compound}
end
