# Read about factories at http://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :sample do
    vial { 1 }
    sampled_at { "2012-01-09 13:37:35" }
  end
end

# == Schema Information
#
# Table name: samples
#
#  id            :integer          not null, primary key
#  vial          :string(255)
#  run_id        :integer
#  sampled_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  uuid          :string(255)
#  incubation_id :integer
#
# Indexes
#
#  index_samples_on_incubation_id  (incubation_id)
#  samples_run_id_vial_key         (run_id,vial) UNIQUE
#
