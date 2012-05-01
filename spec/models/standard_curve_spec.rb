require 'spec_helper'

describe Standard do
  it {should have_many :measurements}
  it {should belong_to :run}
  it {should belong_to :compound}
end
