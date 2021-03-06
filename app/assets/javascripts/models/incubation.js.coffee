class Flux.Models.Incubation extends Backbone.Model

  defaults:
    sampledOn: null
    chamber: null

  initialize: ->
    @fluxes = {}
    if @attributes.co2
      @fluxes['co2'] = new Flux.Models.Flux({id: @attributes.co2.id})
      @fluxes['co2'].set(@attributes.co2)

    if @attributes.n2o
      @fluxes['n2o'] = new Flux.Models.Flux({id: @attributes.n2o.id})
      @fluxes['n2o'].set(@attributes.n2o)

    if @attributes.ch4
      @fluxes['ch4']= new Flux.Models.Flux({id: @attributes.ch4.id})
      @fluxes['ch4'].set(@attributes.ch4)

class Flux.Collections.IncubationsCollection extends Backbone.Collection
  model: Flux.Models.Incubation
  url: '/runs/' + window.run_id
