class IncubationSerializer < ActiveModel::Serializer
  attributes :id, :avg_height_cm, :sampled_at, 
    :soil_temperature, :run_id, :co2, :ch4, :n2o, :name

  def name
    result = "#{object.treatment}#{object.replicate}"
    result += "-#{object.chamber}"  if object.chamber
    result += "-#{object.sub_plot}" if object.sub_plot
    result
  end

end
