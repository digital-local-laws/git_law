class CsvDataUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir
    "db/uploads/#{::Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
   %w(csv)
  end

  def filename
   "data_file.csv" if original_filename
  end
end
