class Flux.Views.IncubationView extends Backbone.View

  initialize: ->
    @.model.bind('change', @.render)

  render: =>
    $(@el).empty()
    $(@el).html(@template())
    $fluxes = @.$('.fluxes')

    view = new Flux.Views.FluxView(model: @model.n2o)
    $fluxes.append(view.render().el)

    view = new Flux.Views.FluxView(model: @model.co2)
    $fluxes.append(view.render().el)

    view = new Flux.Views.FluxView(model: @model.ch4)
    $fluxes.append(view.render().el)
    @

class Flux.Views.IncubationsListView extends Backbone.View
  initialize: ->
    @template = _.template($('incubation-list-template').html())
    @collection.bind('reset', @.render)

  render: =>
    $(@el).html(@template({}))
    @
