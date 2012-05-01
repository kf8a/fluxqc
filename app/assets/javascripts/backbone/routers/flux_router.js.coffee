class Flux.Routers.FluxesRouter extends Backbone.Router

  initialize: (options) ->
    window.incubations = new Flux.Collections.IncubationsCollection
    incubations.reset(INITIAL_DATA)

    @incubationsView = new Flux.Views.IncubationsListView({ 'collection' : incubations})

  routes: {
    ''           : 'home',
    'standards'  : 'standards'
  }

  home: -> 
    sampleTab = $('#sample-tab')
    sampleTab.addClass('active')
    standardTab = $('#standard-tab')
    standardTab.removeClass('active')
    container = $('#container')
    container.empty()
    container.append(@incubationsView.render().el)

  standards: ->
    sampleTab = $('#sample-tab')
    sampleTab.removeClass('active')
    standardTab = $('#standard-tab')
    standardTab.addClass('active')
    container = $('#container')
    # container.empty()
    # container.append(@standardCurves.render().el)
