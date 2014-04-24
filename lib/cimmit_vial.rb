class CimmitVial
  class << self
    def cimmit_vial?(vial)
      vial =~ /([a-z|A-Z]-?\d{3}-T\d)$/
    end

    def cimmit_vial_with_series
      /(S\d+)(-CIM)?-?([a-z|A-Z])-(\d{3}-T\d)$/
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

    def process_cimmit_vial(vial)
      vial = case vial
             when cimmit_vial_with_series
               "#{$1}#{$2}-#{$3}-#{$4}"
             when cimmit_vial_with_spaces
               "#{$1}-#{$2}"
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
