require 'csv'
namespace :util do
  desc "compute ppms from data in file"
  task :to_ppm => :environment do
    c = Compound.where(name: 'n2o').first
    CSV.foreach("parsed.csv") do |line|
      run_id, x, name, area = line
      next unless run_id
      run = Run.find(run_id)
      next unless run
      standard_curves = run.standard_curves_for(c)
      standard_curve = standard_curves.first
      next unless standard_curve
      unless standard_curve.slope
        standard_curve = run.standard_curves.last
      end
      if standard_curve.slope
        ppm = standard_curve.slope * area.to_f + standard_curve.intercept
        CSV { |csv_out| csv_out << [run_id, run.sampled_on, area, standard_curve.slope, standard_curve.intercept, ppm]}
      end
    end
  end
end
