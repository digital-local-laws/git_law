After do
  data_directory = File.expand_path(File.dirname(__FILE__) + "../../../db/#{::Rails.env}")
  if File.directory?(data_directory)
    FileUtils.rm_rf data_directory
  end
#  while $temporary_files.any?
#    file = $temporary_files.pop
#    File.unlink file.path if File.exists? file.path
#  end
end
