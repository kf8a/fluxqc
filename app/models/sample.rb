class Sample < ActiveRecord::Base
  has_many :measurements
  has_many :standards
  belongs_to :run
  belongs_to :incubation

  attr :seconds

  # TODO need to do this before save
  before_save :make_uuid, :if => Proc.new {|object| object.uuid.nil? }

  def data(compound_name)
    measurements.by_compound(compound_name)
  end

  def seconds=(s)
    measurements.each do |m|
      m.seconds = s
      m.save
    end
  end

  def seconds
    measurements.first.seconds
  end

  private
  def make_uuid
    self.uuid = UUID.new.generate
  end
end
# == Schema Information
#
# Table name: samples
#
#  id         :integer         not null, primary key
#  vial       :string(255)
#  run_id     :integer
#  sampled_at :datetime
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

