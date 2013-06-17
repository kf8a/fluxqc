# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Compound.create([{:name => 'n2o', :mol_weight => 28},
                 {:name => 'co2', :mol_weight => 12},
                 {:name => 'ch4', :mol_weight => 12}])
Lid.create([{:name => 'A', :volume => 8, :surface_area => 765, :height=>9},
            {:name => 'B', :volume => 8, :surface_area => 765, :height=>9},
            {:name => 'C', :volume => 8, :surface_area => 765, :height=>9},
            {:name => 'D', :volume => 8, :surface_area => 765, :height=>9},
            {:name => 'Y'}])
