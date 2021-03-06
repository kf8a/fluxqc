class Flux.Models.StandardCurve extends Backbone.Model
  urlRoot: '/standard_curves'

  defaults:
    id:       null
    data:     null
    compound: null

  togglePoint: (point) ->
    point.deleted = !point.deleted
    @.fitLineByLeastSquares()
    @.save()
    @

  to_ppm: (area, eq) ->
    area * eq.slope + eq.offset

  updateSamples: ->
    # @fitLineByLeastSquares()
    eq = @.get('fit_line')
    for incubation in incubations.models
      compound = @get('compound')
      model = incubation.fluxes[compound.name]
      data = model.get('data')

      for datum in  data
        datum.value = @to_ppm(datum.area,eq)

      model.set({'data':data})

      model.fitLineByLeastSquares()
      model.save()

  fitLineByLeastSquares: ->
    sum_x = sum_y = sum_xy = sum_xx = sum_yy = count = 0
    x = y = 0

    if (@.attributes.data.length < 2)
      return [ [], [] ]

    for v in [0..@.attributes.data.length-1]
      unless @attributes.data[v].deleted
        x = @attributes.data[v].key
        y = @attributes.data[v].value
        sum_x  += x
        sum_y  += y
        sum_xx += x*x
        sum_yy += y*y
        sum_xy += x*y
        count++

    m = (count * sum_xy - sum_x * sum_y)/(count * sum_xx - sum_x * sum_x)
    b = (sum_y/count) - (m * sum_x)/count

    mean_y = sum_y/count
    sst = sse = 0

    correlation = (count * sum_xy - sum_x * sum_y)/Math.sqrt((count * sum_xx - sum_x * sum_x)*(count * sum_yy - sum_y * sum_y))
    correlation = correlation * correlation

    r2 = correlation
    @.set({fit_line: {slope: m, r2: r2, offset: b}})

    [m,b,r2]

class Flux.Collections.StandardCurvesCollection extends Backbone.Collection
  model: Flux.Models.StandardCurve
  url: '/runs/' + window.run_id + '/standard_curves'
