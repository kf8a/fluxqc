require 'spec_helper'

describe Sample do
  it {should have_many :measurements}
end
