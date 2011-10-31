class Flux.Models.Incubation extends Backbone.Model

  defaults:
    sampledOn: null
    chamber: null
    n2o: 1
    co2: 2
    ch4: 3

  initialize: ->
    @co2_model = new Flux.Models.Flux({id: 1})
    @co2_model.fetch()

    @n2o_model = new Flux.Models.Flux({id: 1})
    @n2o_model.fetch()

    @ch4_model = new Flux.Models.Flux({id: 1})
    @ch4_model.fetch()
  
class Flux.Collections.IncubationsCollection extends Backbone.Collection
  model: Flux.Models.Incubation
  url: '/incubations'
