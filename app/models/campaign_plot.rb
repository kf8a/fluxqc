class CampaignPlot < ActiveRecord::Base
  belongs_to :plot
  belongs_to :campaign
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
