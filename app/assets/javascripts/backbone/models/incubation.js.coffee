class Flux.Models.Incubation extends Backbone.Model

  defaults:
    sampledOn: null
    chamber: null

  initialize: ->
    @co2_model = new Flux.Models.Flux({id: @attributes.co2.id})
    @co2_model.set(@attributes.co2)

    @n2o_model = new Flux.Models.Flux({id: @attributes.n2o.id})
    @n2o_model.set(@attributes.n2o)

    @ch4_model = new Flux.Models.Flux({id: @attributes.ch4.id})
    @ch4_model.set(@attributes.ch4)
  
class Flux.Collections.IncubationsCollection extends Backbone.Collection
  model: Flux.Models.Incubation
  # url: '/runs/' + window.run_id
