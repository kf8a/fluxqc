class Plot < ActiveRecord::Base
  has_many :campaign_plot
  has_many :campaigns, :through => :campaign_plot
end
