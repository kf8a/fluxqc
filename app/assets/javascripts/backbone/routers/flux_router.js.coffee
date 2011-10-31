class Flux.Routers.FluxesRouter extends Backbone.Router

  initialize: (options) ->
    incubations = new Flux.Collections.IncubationsCollection
    @incubationsView = new Flux.Views.IncubationsListView({ 'collection' : incubations})
    incubations.fetch()
    # fluxes = new Flux.Collections.FluxesCollection
    # @fluxesView = new Flux.Views.FluxesListView({ 'collection' : fluxes})
    # fluxes.fetch()

    
  routes: {
    '': 'home' 
  }

  home: -> 
    container = $('#container')
    container.empty()
    # container.append(@fluxesView.render().el)
    container.append(@incubationsView.render().el)
