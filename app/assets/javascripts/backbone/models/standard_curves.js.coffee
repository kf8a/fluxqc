class Flux.Models.StandardCurve extends Backbone.Model
  paramRoot: 'standard_curves'

  initialize: ->
    @co2_model = new Flux.Models.Flux({id: @attributes.co2.id})
    @co2_model.set(@attributes.co2)

    @n2o_model = new Flux.Models.Flux({id: @attributes.n2o.id})
    @n2o_model.set(@attributes.n2o)

    @ch4_model = new Flux.Models.Flux({id: @attributes.ch4.id})
    @ch4_model.set(@attributes.ch4)

class Flux.Collections.StandardCurvesCollection extends Backbone.Collection
  model: Flux.Models.StandardCurve
  url: '/runs/' + window.run_id + '/standard_curves'
