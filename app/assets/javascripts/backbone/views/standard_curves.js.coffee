class Flux.Views.StandardCurveView extends Backbone.View
  tagName: 'span'

  initialize: ->
    @.model.bind('change', @.render)

  render: =>
    # need to remove the plot i think
    $(@el).empty()
    scatterPlot(@model, @el,600)
    @

class Flux.Views.StandardCurvesListView extends Backbone.View
  tagName: 'p'

  initialize: ->
    @collection.bind('reset', @.render)

  listItemView: (standardCurve) -> 
    view = new Flux.Views.StandardCurveView(model: standardCurve)
    view.render().el

  render: =>
    $(@el).append(@.listItemView(standardCurve)) for standardCurve in @collection.models
    @
