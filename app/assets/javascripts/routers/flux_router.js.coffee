class Flux.Routers.FluxesRouter extends Backbone.Router

  initialize: (options) ->
    window.incubations = new Flux.Collections.IncubationsCollection
    incubations.reset(INITIAL_DATA)
    window.standardCurves = new Flux.Collections.StandardCurvesCollection

    standardCurves.reset(INITIAL_STANDARD_DATA)
    window.incubationsView = new Flux.Views.IncubationsListView({ 'collection' : incubations})
    window.standardCurvesListView = new Flux.Views.StandardCurvesListView( {'collection' : standardCurves })

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
    container.append(incubationsView.render().el)

  standards: ->
    sampleTab = $('#sample-tab')
    sampleTab.removeClass('active')
    standardTab = $('#standard-tab')
    standardTab.addClass('active')
    container = $('#container')
    container.empty()
    standardCurves.url = '/runs/' + window.run_id + '/standard_curves'
    standardCurves.fetch()
    container.append(standardCurvesListView.render().el)
