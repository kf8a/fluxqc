namespace :util do
  desc "move times zero to zero"
  task :to_zero => :environment do
    i = Incubation.where(%q{treatment like 'G%'}).find_each do |i|
      f = i.co2.measurements.all.sort {|a,b| a.seconds <=> b.seconds}.first
      i.co2.measurements.each do |m|
        m.original_seconds = m.seconds
        m.seconds = m.seconds - f.seconds
        m.save
        p [i.treatment, m.seconds, f.seconds, m.original_seconds]
      end
      f = i.n2o.measurements.all.sort {|a,b| a.seconds <=> b.seconds}.first
      i.n2o.measurements.each do |m|
        m.original_seconds = m.seconds
        m.seconds = m.seconds - f.seconds
        m.save
      end
      f = i.ch4.measurements.all.sort {|a,b| a.seconds <=> b.seconds}.first
      i.ch4.measurements.each do |m|
        m.original_seconds = m.seconds
        m.seconds = m.seconds - f.seconds
        m.save
      end
      p '----'
    end
  end
end
