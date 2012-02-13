class Campaign < ActiveRecord::Base
  has_many :campaign_plots
  has_many :plots, :through => :campaign_plot
end
