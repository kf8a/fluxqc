require 'spec_helper'

describe CampaignPlot do
  it {should belong_to :plot}
  it {should belong_to :campaign}
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
