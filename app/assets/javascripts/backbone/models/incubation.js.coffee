class Flux.Models.Incubation extends Backbone.Model
  paramRoot: 'incubation'

  defaults:
    sample_date: null
    chamber: null
    n2o: null
    co2: null
    ch4: null
  
class Flux.Collections.IncubationsCollection extends Backbone.Collection
  model: Flux.Models.Incubation
  url: '/incubations'
