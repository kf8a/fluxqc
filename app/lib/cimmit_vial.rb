# frozen_string_literal: true

# Provide patterns for seeing if the name is a cimit name
class CimmitVial
  class << self
    def cimmit_vial?(vial)
      vial =~ /([a-z|A-Z]-?\d{3}-T\d)$/
    end

    def cimmit_vial_with_series
      /(S\d+)(-CIM)?[-| ]([a-z|A-Z])-(\d{3}-T\d)$/
    end

    def cimmit_vial_with_series_and_dash_plus_space
      /(S\d+)(-CIM)?- ([a-z|A-Z])-(\d{3}-T\d)$/
    end

    def cimmit_vial_with_spaces
      /(S\d+) ([a-z|A-Z]-\d{3}-T\d)$/
    end

    def vial_with_series_and_no_dash
      /(S\d+) ([a-z|A-Z])(\d{3}-T\d)$/
    end

    def cimmit_vial_with_dashes
      /([a-z|A-Z]-\d{3}-T\d)$/
    end

    def cimmit_vial_without_dashes
      /([a-z|A-Z])(\d{3}-T\d)$/
    end

    def cimmit_vial_order_1
      /(S\d+-CIM)-(\d+)-([a-z|A-Z])-(T\d)$/
    end

    def cimmit_vial_order_2
      /(CIM)-(S\d+)-(\d+)-([F|B])-(T\d)$/
    end

    def cimmit_vial_order_3
      /(S\d+-CIM)-(\d+)-([F|B])-(T\d)$/
    end

    def cimmit_vial_order_4
      /(CIM)-(S\d+)-([F|B])-(\d+)-(T\d)$/
    end

    def process_cimmit_vial(vial)
      vial = case vial
             when cimmit_vial_order_1
               "#{$1}-#{$3}-#{$2}-#{$4}"
             when cimmit_vial_order_2
               "#{$2}-#{$1}-#{$4}-#{$3}-#{$5}"
             when cimmit_vial_order_3
               "#{$1}-#{$3}-#{$2}-#{$4}"
             when cimmit_vial_order_4
               "#{$2}-#{$1}-#{$3}-#{$4}-#{$5}"
             when cimmit_vial_with_series
               "#{$1}#{$2}-#{$3}-#{$4}"
             when cimmit_vial_with_spaces
               "#{$1}-#{$2}"
             when cimmit_vial_with_series_and_dash_plus_space
               "#{$1}#{$2}-#{$3}-#{$4}"
             when vial_with_series_and_no_dash
               "#{$1}-#{$2}-#{$3}"
             when cimmit_vial_with_dashes
               vial = $1
             else vial =~ cimmit_vial_without_dashes
               vial = "#{$1}-#{$2}"
             end
    end
  end
end
