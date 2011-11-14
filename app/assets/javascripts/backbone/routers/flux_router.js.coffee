class Flux.Routers.FluxesRouter extends Backbone.Router

  initialize: (options) ->
    window.incubations = new Flux.Collections.IncubationsCollection
    incubations.reset(INITIAL_DATA)
    @incubationsView = new Flux.Views.IncubationsListView({ 'collection' : incubations})

  routes: {
    '': 'home' 
  }

  home: -> 
    container = $('#container')
    container.empty()
    container.append(@incubationsView.render().el)
