# We are not using capybara-webkit because of its inadequate PATCH support
# See https://github.com/thoughtbot/capybara-webkit/issues/553
# require 'capybara-webkit'
# Capybara.javascript_driver = :webkit
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
