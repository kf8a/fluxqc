class Flux.Models.Standard extends Backbone.Model
  paramRoot: 'standard'

  defaults:
    id:       null
    data:     null
    compound: null

class Flux.Collections.StandardsCollection extends Backbone.Collection
  model: Flux.Models.Standard
  url: '/standards'
