require 'spec_helper'

describe Sample do
  it {should have_many :measurements}
  it {should belong_to :run}
end
