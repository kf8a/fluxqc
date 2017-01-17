module ApplicationHelper
  def json_for(target, options = {})
    options[:scope] ||= self
    options[:url_options] ||= url_options
    # ActiveModel::ArraySerializer.new(target).to_json
    ActiveModel::Serializer::CollectionSerializer.new(target).to_json
    # target.active_model_serializer.new(target, options).to_json
  end

  def recent(model)
    if model.updated_at
      "recent_" + (model.updated_at > 3.weeks.ago).to_s
    else
      "unkown"
    end
  end
end
