AfterConfiguration do
  # Remove existing public folder
  # if File.exist?( Rails.root.join "public" )
  #   FileUtils.rm_rf Rails.root.join( "public" )
  # end
  # Build new public folder based on current assets
  built = system("cd \"#{File.join Rails.root, 'client'}\" && gulp build")
  unless built
    raise 'Failure to build.'
  end
  system("cd \"#{Rails.root}\"")
end
