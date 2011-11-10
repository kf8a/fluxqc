class Flux.Models.Incubation extends Backbone.Model

  defaults:
    sampledOn: null
    chamber: null

  initialize: ->
    @co2_model = new Flux.Models.Flux({id: @attributes.co2})
    @co2_model.fetch()

    @n2o_model = new Flux.Models.Flux({id: @attributes.n2o})
    @n2o_model.fetch()

    @ch4_model = new Flux.Models.Flux({id: @attributes.ch4})
    @ch4_model.fetch()
  
class Flux.Collections.IncubationsCollection extends Backbone.Collection
  model: Flux.Models.Incubation
  url: '/runs/' + window.run_id
