# == Schema Information
#
# Table name: data_files
#
#  id         :integer          not null, primary key
#  run_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DataFile < ActiveRecord::Base
  belongs_to :run

  mount_uploader :file, DataUploader
end
