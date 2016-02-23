AfterConfiguration do
  built = system("cd \"#{File.join Rails.root, 'client'}\" && gulp build")
  unless built
    raise 'Failure to build.'
  end
  system("cd \"#{Rails.root}\"")
end

at_exit do
  FileUtils.rm_rf Rails.root.join( "public" )
end
