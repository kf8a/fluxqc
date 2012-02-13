class CampaignPlot < ActiveRecord::Base
  belongs_to :plot
  belongs_to :campaign
end
