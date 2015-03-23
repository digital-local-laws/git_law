RSpec.configure do |config|
  config.after(:each) do
    FileUtils.rm_r("#{::Rails.root}/db/#{::Rails.env}", force: true)
  end
end
