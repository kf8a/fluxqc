describe("Standards", function() {

  var MOCK_STANDARD_DATA = {
    coeff: null, 
  column: 0,
  compound: {id:3, name:"ch4", mol_weight:12, unit:"ppm", ymax:2, ymin:0},
  id: 3,
  mol_weight: 12,
  name: "ch4",
  unit: "ppm",
  ymax: 2,
  ymin: 0,
  compound_id: 3,
  created_at: "2014-04-01T18:52:18.972Z",
  data: [
    {id:6036, key:27.587278, value:0, name:"STD00A", deleted:null},
    {id:6039, key:32.556156, value:0.565, name:"STD07A", deleted:null},
    {id:6045, key:34.70882, value:0.806, name:"STD10A", deleted:null},
    {id:6042, key:39.568546, value:1.21, name:"STD15A", deleted:null},
    {id:6048, key:40.545422, value:1.613, name:"STD20A", deleted:null},
    {id:6051, key:45.090057, value:2.419, name:"STD30A", deleted:null},
    {id:6054, key:50.252453, value:3.226, name:"STD40A", deleted:null}
  ],
  fit_line: { offset: -1.1849844311358793, r2: 0.8885123049242689, slope: 0.07783319452961618},
  id: 757,
  intercept: null,
  run_id: 804,
  slope: null,
  updated_at: "2014-04-01T18:52:18.972Z",
  };

  describe('computing the slope', function() {
    var eq, curve = null;

    beforeEach(function() {
      window.incubations = new Flux.Collections.IncubationsCollection();
      console.log(incubations);
      curve = new Flux.Models.StandardCurve(MOCK_STANDARD_DATA);
      curve.fitLineByLeastSquares();
      eq = curve.get('fit_line')
    });

    it('should be a valid object', function() {
      console.log(curve);
      expect(curve).toBeDefined();
    });

    it("should return the right values from the line fit", function() {
      fit = curve.fitLineByLeastSquares();
      expect(fit[0]).toBe(eq.slope);
      expect(fit[1]).toBe(eq.offset);
    });

    it("should have current data", function() {
      expect(curve.get('data')[0]['key']).toBe(27.587278);
    });

    it("should compute the right slope", function() {
      expect(eq.slope).toBe(0.1431395782167758);
    });

    it("should compute the right intercept", function() {
      expect(eq.offset).toBe(-4.12183969811307);
    });

    it("should compute the right ppm", function() {
      expect(curve.to_ppm(39.003429,eq)).toBe(1.4610946779548915);
    });
  });

});
