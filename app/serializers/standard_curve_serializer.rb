class StandardCurveSerializer < ActiveModel::Serializer
  attributes :id, :slope, :intercept, :compound_id, :run_id,
    :data, :fit_line, :compound
end
