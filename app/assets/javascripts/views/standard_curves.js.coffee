class Flux.Views.StandardCurveView extends Backbone.View
  tagName: 'span'

  initialize: ->
    @model.on('reset', @render)
    @model.on('change', @render)

  render: =>
    # need to remove the plot i think
    $(@el).empty()
    # split into standard and checks
    json_data = @model.toJSON()
    data = json_data.data 
    std = (datum for datum in data when datum.name[0] != 'C')
    chk = (datum for datum in data when datum.name[0] == 'C')

    plot = new Flux.ScatterPlot()
    plot.data(std)
    plot.fitLine(json_data.fit_line)
    plot.model(@model)
    plot.render(@el)

    # plot = new Flux.ScatterPlot()
    # plot.data(chk)
    # plot.model(@model)
    # plot.render(@el)
    this

class Flux.Views.StandardCurvesListView extends Backbone.View

  initialize: ->
    @collection.bind('reset', @.render)

  listItemView: (standardCurve) -> 
    view = new Flux.Views.StandardCurveView(model: standardCurve)
    $(@el).append(view.render().el)
    view.render()
    this

  render: =>
    @.listItemView(standardCurve) for standardCurve in @collection.models
    @
