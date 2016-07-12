require 'capybara-screenshot/cucumber'
Capybara.save_path = File.join( ::Rails.root, 'tmp/capybara' )
Capybara::Screenshot.prune_strategy = { keep: 5 }
