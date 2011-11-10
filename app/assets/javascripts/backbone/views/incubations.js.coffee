class Flux.Views.IncubationView extends Backbone.View
  tagName: 'li'

  initialize: ->
    _.templateSettings = {
      interpolate : /\{\{(.+?)\}\}/g
    }
    @template = _.template($('#incubation-template').html())
    @.model.bind('change', @.render)

  render: =>
    $(@el).empty()
    $(@el).append(@template(@model.toJSON()))

    view = new Flux.Views.FluxView(model: @model.n2o_model)
    $(@el).append(view.render().el)

    view = new Flux.Views.FluxView(model: @model.co2_model)
    $(@el).append(view.render().el)

    view = new Flux.Views.FluxView(model: @model.ch4_model)
    $(@el).append(view.render().el)
    @

class Flux.Views.IncubationsListView extends Backbone.View
  tagName: 'ul'

  initialize: ->
    @collection.bind('reset', @.render)

  listItemView: (incubation) -> 
    view = new Flux.Views.IncubationView(model: incubation)
    view.render().el

  render: =>
    $(@el).append(@.listItemView(incubation)) for incubation in @collection.models
    @
