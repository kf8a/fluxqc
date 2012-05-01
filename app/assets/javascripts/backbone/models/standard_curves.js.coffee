class Flux.Models.StandardCurve extends Backbone.Model
  paramRoot: 'standard_curves'

  defaults:
    id:       null
    data:     null
    compound: null

class Flux.Collections.StandardCurvesCollection extends Backbone.Collection
  model: Flux.Models.StandardCurve
  url: '/standard_curves'
