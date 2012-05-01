class Flux.Views.StandardCurveView extends Backbone.View
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

    view = new Flux.Views.StandardCurveView(model: @model.n2o_model)
    $(@el).append(view.render().el)

    view = new Flux.Views.StandardCurveView(model: @model.co2_model)
    $(@el).append(view.render().el)

    view = new Flux.Views.StandardCurveView(model: @model.ch4_model)
    $(@el).append(view.render().el)
    @

class Flux.Views.StandardCurvesListView extends Backbone.View
  tagName: 'ul'

  initialize: ->
    @collection.bind('reset', @.render)

  listItemView: (standardCurve) -> 
    view = new Flux.Views.StandardCurveViewView(model: standardCurve)
    view.render().el

  render: =>
    $(@el).append(@.listItemView(standardCurve)) for standardCurve in @collection.models
    @
