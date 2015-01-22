require 'rails_helper'

describe CampaignPlot do
  it {is_expected.to belong_to :plot}
  it {is_expected.to belong_to :campaign}
end

# == Schema Information
#
# Table name: campaign_plots
#
#  id          :integer          not null, primary key
#  plot_id     :integer
#  campaign_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#
