class Flux.Views.FluxView extends Backbone.View

  initialize: ->
    @.model.bind('change', @.render)

  render: =>
    # need to remove the plot i think
    $(@el).empty()
    scatterPlot(@model, @el)
    @

class Flux.Views.FluxesListView extends Backbone.View

  initialize: ->
    @template  = _.template($('#flux-list-template').html())
    @collection.bind('reset', @.render)

  renderFlux: (flux, $fluxes) ->
    view = new Flux.Views.FluxView(model: flux)
    $fluxes.append(view.render().el)
    @

  render: =>
    $(@el).empty()
    $(@el).html(@template({}))
    $fluxes = @.$('.fluxes')

    @renderFlux(flux, $fluxes) for flux in @collection.models
    @
