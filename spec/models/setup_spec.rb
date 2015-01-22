require 'rails_helper'

describe Setup do
  it {is_expected.to belong_to :template}
end

# == Schema Information
#
# Table name: setups
#
#  id          :integer          not null, primary key
#  template_id :integer
#  sample_date :date
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
