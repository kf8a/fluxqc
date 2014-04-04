require 'spec_helper'

describe Calibration do
  it {should belong_to :standard_curve}
  it {should belong_to :sample}
end
