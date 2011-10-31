class Flux.Models.Flux extends Backbone.Model
  paramRoot: 'flux'

  defaults:
    data: null
    compound: null
  
  togglePoint: (point) ->
    point.deleted = !point.deleted
    @.change()
    @

  fitLineByLeastSquares: =>
    sum_x = sum_y = sum_xy = sum_xx = count = 0 
    x = y = 0

    if (@.attributes.data.length == 0)
      return [ [], [] ]

    for v in [0..@.attributes.data.length-1]
      unless @attributes.data[v].deleted
        x = @attributes.data[v].key
        y = @attributes.data[v].value
        sum_x  += x
        sum_y  += y
        sum_xx += x*x
        sum_xy += x*y
        count++

    m = (count * sum_xy - sum_x * sum_y)/(count * sum_xx - sum_x * sum_x)
    b = (sum_y/count) - (m * sum_x)/count

    mean_y = sum_y/count
    sst = sse = 0

    for v in [0..@.attributes.data.length-1]
      unless @attributes.data[v].deleted
        x = @attributes.data[v].key
        y = @attributes.data[v].value
        sst = (y - mean_y) * (y - mean_y)
        fy = m * x + b
        sse = (y - fy) * (y - fy)

    r2 = 1 - (sse/sst)
    [m, b, r2]

class Flux.Collections.FluxesCollection extends Backbone.Collection
  model: Flux.Models.Flux
  url: '/fluxes'
