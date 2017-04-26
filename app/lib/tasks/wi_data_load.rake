require 'csv'
require 'chronic'
namespace :util do
  desc "load wi data"
  task :load_wi => :environment do
    # remove all data
    Run.where('name like ?', 'UW%').each do |run|
      run.destroy
    end
    i = 0
    samples = []
    setups = {}
    results = {}
    sample_dates = []
    CSV.foreach("wi-concentration.csv") do |row|
date,site,year,block,plot,key,trt,bucket_type,run_time,deployment_time,bucket_height,surface_diameter,interior_height,surface_area,chamber_volume,air_t,id,co2_ppm,n2o_ppm,ch4_ppm,n2o_per_vol,n2o_per_area,flag_for_errors,id_for_error,series = row
      next if site == 'mi'
      next if block == 'block'

      i = i+1

      lid = 'Y'
      lid = 'X' if bucket_type == 'plastic'

      setups[date] = [] unless setups[date]
      sample_dates << date
      setups[date] << {run_name: 'wisconsin', sample_date: date, treatment: key, replicate: block,
        sub_plot: '', chamber: '1', :vial => i.to_s, lid: lid, height: [bucket_height.to_f], seconds: deployment_time.to_f*60, comments: ''}

      results[date] = [] unless results[date]
      results[date] << {vial: i.to_s, 
        n2o: {ppm: n2o_ppm.to_f},
        co2: {ppm: co2_ppm.to_f}, 
        ch4: {ppm: ch4_ppm.to_f}}

    end
    sample_dates.uniq!.sort! {|a,b| Chronic.parse(a) <=> Chronic.parse(b) }
    i = 0
    sample_dates.each do |sample_date|
      i = i+1
      p sample_date
      run = Run.create(name: "UW GlBRC Series #{i}", study: "glbrc", sampled_on: Chronic.parse(sample_date), company_id: 2)
      setups[sample_date].each do |sample|
        run.incubations << IncubationFactory.create(run.id, sample)
      end
      loader = DataFileLoader.new(run)
      loader.process_samples(results[sample_date])
    end
  end
end
