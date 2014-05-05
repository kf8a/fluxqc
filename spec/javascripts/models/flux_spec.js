describe("Flux", function() {
  var MOCK_FLUX_DATA =  {"id":86235,"incubation_id":28745,"value":-0.037799256309242,"compound_id":3,"created_at":"2014-04-03T15:59:51.639Z","updated_at":"2014-04-03T16:02:19.689Z","data":[{"id":346414,"key":0,"value":0.883674904040492,"area":28.8381,"deleted":false},{"id":346420,"key":27,"value":0.851982687149839,"area":28.1383,"deleted":false},{"id":346423,"key":41,"value":0.881596206190704,"area":28.7922,"deleted":false},{"id":346417,"key":12,"value":0.853748901009135,"area":28.1773,"deleted":false}],"compound":{"id":3,"name":"ch4","mol_weight":12.0,"unit":"ppm","ymax":2.0,"ymin":0.0},"expected_slope":"negative","ymax":2.0,"ymin":0,"fit_line":{"slope":-2.7348164391267143e-05,"offset":0.8682976378853678,"r2":0.0008017422635627979},"multiplier":1382.1496671020484,"flux":-0.037799256309241976, "standards":[{"id":1},{"id":2}]};

  var flux;
  beforeEach(function() {
    flux = new Flux.Models.Flux(MOCK_FLUX_DATA);
  });

  it('creates a test flux', function() {
    expect(flux).toBeDefined();
  });

  it("has the right data", function() {
    data = flux.get('data')

    expect(data).toBeDefined();
  expect(data[0]['key']).toBe(0);
  });

  describe("standard handling", function() {
    var standards;
    beforeEach(function() {
      standards = flux.get('standards');
    });

    it("sets up the standards", function() {
      expect(standards.length).toBe(2);
    });

  });
});
