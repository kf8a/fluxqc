class Flux.Views.StandardCurveView extends Backbone.View
  tagName: 'span'

  initialize: ->
    _.templateSettings = {
      interpolate : /\{\{(.+?)\}\}/g
    }
    @template = _.template($('#standard-template').html())
    @.model.on('change', @render)

  render: =>
    # need to remove the plot i think
    $(@el).empty()
    json_data = @model.toJSON()
    $(@el).append(@template(json_data.fit_line))

    plot = new Flux.ScatterPlot()
    # plot.data(json_data.data)
    plot.fitLine(json_data.fit_line)
    plot.model(@model)
    plot.render(@el)

    @

class Flux.Views.StandardCurvesListView extends Backbone.View

  initialize: ->
    @collection.bind('reset', @.render)

  listItemView: (standardCurve) -> 
    view = new Flux.Views.StandardCurveView(model: standardCurve)
    view.render().el

  render: =>
    $(@el).empty()
    $(@el).append(@.listItemView(standardCurve)) for standardCurve in @collection.models
    @
