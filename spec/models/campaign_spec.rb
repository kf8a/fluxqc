require 'spec_helper'

describe Campaign do
  it {should have_many :plots}
end
