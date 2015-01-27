class IncubationSerializer < ActiveModel::Serializer
  attributes :id, :avg_height_cm, :sampled_at, 
    :soil_temperature, :run_id, :co2, :ch4, :n2o, :name

   delegate :cache_key, :to => :object

  def name
    result = "#{object.treatment}#{object.replicate}"
    result += "-#{object.chamber}"  if object.chamber
    result += "-#{object.sub_plot}" if object.sub_plot
    result
  end

  # Cache entire JSON string
  def to_json(*args)
    Rails.cache.fetch expand_cache_key(self.class.to_s.underscore, cache_key, 'to-json') do
      super
    end
  end

  # Cache individual Hash objects before serialization
  # This also makes them available to associated serializers
  def serializable_hash
    Rails.cache.fetch expand_cache_key(self.class.to_s.underscore, cache_key, 'serilizable-hash') do
      super
    end
  end

  private
  def expand_cache_key(*args)
    ActiveSupport::Cache.expand_cache_key args
  end

end
