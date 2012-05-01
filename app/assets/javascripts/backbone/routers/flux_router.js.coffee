class Flux.Routers.FluxesRouter extends Backbone.Router

  initialize: (options) ->
    window.incubations = new Flux.Collections.IncubationsCollection
    if (typeof INITIAL_DATA != 'undefined')
      incubations.reset(INITIAL_DATA)

    @incubationsView = new Flux.Views.IncubationsListView({ 'collection' : incubations})

  routes: {
    ''          : 'home',
    'standards' : 'standards'
  }

  home: -> 
    container = $('#container')
    container.empty()
    container.append(@incubationsView.render().el)

  standards: ->
    container = $('#container')
    container.empty()
    container.append(@standardsView.render().el)
