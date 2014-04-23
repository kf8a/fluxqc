class Plot < ActiveRecord::Base
  has_many :campaign_plot
  has_many :campaigns, :through => :campaign_plot
end

# == Schema Information
#
# Table name: plots
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
