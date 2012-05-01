class Fluxqc.Models.Standard extends Backbone.Model
  paramRoot: 'standard'

  defaults:
    id:       null
    data:     null
    compound: null

class Fluxqc.Collections.StandardsCollection extends Backbone.Collection
  model: Fluxqc.Models.Standard
  url: '/standards'
