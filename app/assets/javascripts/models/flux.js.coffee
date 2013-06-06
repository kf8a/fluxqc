class Flux.Models.Flux extends Backbone.Model
  urlRoot: '/fluxes'

  defaults:
    id:       null
    data:     null
    compound: null

  togglePoint: (point) ->
    point.deleted = !point.deleted
    @.fitLineByLeastSquares()
    @.change()
    @

  fitLineByLeastSquares: =>
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
    new_flux = m  * @attributes.multiplier
    @.set({flux: new_flux})
    @.set({fit_line: {slope: m, r2: r2, offset: b}})

    @.save()
    [m,b,r2, @attributes.flux]

class Flux.Collections.FluxesCollection extends Backbone.Collection
  model: Flux.Models.Flux
  url: '/fluxes'
