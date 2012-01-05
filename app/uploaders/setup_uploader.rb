# encoding: utf-8

class SetupUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(csv)
  end


  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  
  #
  # # Parse the input and generate the required samples
  # process :parse

  # # Parse the input file here 
  # def parse 
  #   # check the file extension
  #   samples = parse_csv(file)
  #   samples.each do |sample|
  #     incubation = IncbuationFactory.create(sample)
  #     incubation.save
  #   end
  # end
end
