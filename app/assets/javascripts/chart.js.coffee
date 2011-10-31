window.scatterPlot = (model, el) -> 

  data = model.toJSON().data
  return unless data

  height = 300
  width  = 300
  margin = 50

  chart = d3.select(el)
   .append('svg:svg')
   .attr('class', 'chart')
   .attr('width', height)
   .attr('height', height)

  y = d3.scale.linear()
   .domain([0, d3.max(data, (d)->d.value)])
   .range([margin, height - margin])

  x = d3.scale.linear()
    .domain([0, d3.max(data, (d) -> d.key)])
    .range([margin, height - margin])

  g = chart.append('svg:g')
    .attr('transform', 'translate(0,' + height + ' ) scale(1,-1)')

  # add dots
  g.selectAll('path')
    .data(data)
    .enter().append('svg:path')
    .attr('class', 'path')
    .attr("transform", (d,i) -> "translate(" + x(d.key) + "," + y(d.value) + ")")
    .attr('d', d3.svg.symbol())
    .style('fill', (d) -> if d.deleted then 'white' else 'blue')
    .attr('stroke', 'blue')
    .on('click', (d) -> d3.select(this).transition().duration(300).style('fill', 'grey'); model.togglePoint(d))

  # x axis
  g.append('svg:line')
    .attr("stroke", "#A8A8A8")
    .attr('x1', x(0))
    .attr('y1', y(0))
    .attr('x2', x(d3.max(data, (d)->d.key)))
    .attr('y2', y(0))

  g.selectAll('.xTickMarks')
    .data(x.ticks(5))
    .enter().append('svg:line')
    .attr('stroke', '#A8A8A8')
    .attr('x1', (d) -> x(d))
    .attr('y1',y(0))
    .attr('x2', (d) -> x(d))
    .attr('y2',margin - 5)

  # #tick labels 
  g.selectAll('.xLabel')
    .data(x.ticks(5))
    .enter().append('svg:text')
    .attr('transform', 'scale(1, -1)')
    .attr('class','xLabel label')
    .text(String)
    .attr('x', (d) -> x(d))
    .attr('y', - (margin - 20 ))
    .attr('text-anchor', 'middle')

  #  axis
  g.append('svg:line')
    .attr('stroke', '#A8A8A8')
    .attr('x1', x(0))
    .attr('y1', y(0))
    .attr('x2', x(0))
    .attr('y2', y(d3.max(data, (d)->d.value)))

  # tick labels 
  g.selectAll('.yLabel')
    .data(y.ticks(5))
    .enter().append('svg:text')
    .attr('transform', 'scale(1,-1)')
    .attr('class','yLabel label')
    .text(String)
    .attr('x', margin-15)
    .attr('y', (d) -> -y(d))
    .attr('dy', 4)
    .attr('text-anchor', 'middle')

  g.selectAll('.yTickMarks')
    .data(y.ticks(5))
    .enter().append('svg:line')
    .attr('stroke', '#A8A8A8')
    .attr('x1', x(0))
    .attr('y1',(d) -> y(d))
    .attr('x2', margin - 5)
    .attr('y2',(d) -> y(d))

  # add fit line
  [m, b, r2] = model.fitLineByLeastSquares()

  # find first and last point
  a1 = 0 * m + b
  a2 = d3.max(data, (d) -> d.key) * m + b

  g.append('svg:text')
    .attr('transform', 'scale(1,-1)')
    .attr('x', width-margin)
    .attr('y',50) 
    .text(r2)

  g.selectAll('.fitLine')
    .data([a1,a2])
    .enter().append('svg:line')
    .attr('class', 'fitLine')
    .attr('stroke', 'red')
    .attr('x1',x(0))
    .attr('y1', y(a1))
    .attr('x2',x(d3.max(data, (d)->d.key)))
    .attr('y2', y(a2))

