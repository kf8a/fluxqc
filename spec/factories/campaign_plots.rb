# Read about factories at http://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :campaign_plot do
    plot_id 1
    campaign_id 1
  end
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
