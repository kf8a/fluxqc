# == Schema Information
#
# Table name: calibrations
#
#  id                :integer          not null, primary key
#  standard_curve_id :integer
#  sample_id         :integer
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

describe Calibration do
  it { is_expected.to belong_to :standard_curve}
  it { is_expected.to belong_to :sample}
end
