class Flux.Views.StandardCurveView extends Backbone.View
  tagName: 'span'

  initialize: ->
    @.model.bind('change', @.render)

  render: =>
    # need to remove the plot i think
    $(@el).empty()
    scatterPlot(@model, @el)
    @

class Flux.Views.StandardCurvesListView extends Backbone.View

  initialize: ->
    @collection.bind('reset', @.render)

  listItemView: (standardCurve) -> 
    view = new Flux.Views.StandardCurveView(model: standardCurve)
    $(@el).append(view.render().el)
    #view.render()
    @

  render: =>
    @.listItemView(standardCurve) for standardCurve in @collection.models
    @
