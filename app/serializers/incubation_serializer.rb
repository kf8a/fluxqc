class IncubationSerializer < ActiveModel::Serializer
  attributes :id, :avg_height_cm, :chamber, :treatment, :replicate, :sampled_at, 
    :soil_temperature, :run_id, :co2, :ch4, :n2o

end
