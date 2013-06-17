class Campaign < ActiveRecord::Base
  has_many :campaign_plots
  has_many :plots, :through => :campaign_plot
end

# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

