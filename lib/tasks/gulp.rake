require 'fileutils'

namespace :gulp do
  desc 'Install dependencies for Gulp tasks on client'
  task :dependencies do
    Dir.chdir( ::Rails.root.join('client') ) do
      system 'npm install'
      system 'bower install'
    end
  end

  desc 'Build asset files from client'
  task :build => [ :dependencies ] do
    Dir.chdir( ::Rails.root.join('client') ) do
      FileUtils.rm_rf ::Rails.root.join('public')
      system 'gulp build'
    end
  end
end
