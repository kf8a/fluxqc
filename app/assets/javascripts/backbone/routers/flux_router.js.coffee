class Flux.Routers.FluxesRouter extends Backbone.Router

  initialize: (options) ->
    # incubations = new Flux.Collections.Incubations
    # @incubationsView = new Flux.Views.IncubationListView({ 'collection' : incubations})
    fluxes = new Flux.Collections.FluxesCollection
    @fluxesView = new Flux.Views.FluxesListView({ 'collection' : fluxes})
    fluxes.fetch()

    
  routes: {
    '': 'home' 
  }

  home: -> 
    container = $('#container')
    container.empty()
    container.append(@fluxesView.render().el)
