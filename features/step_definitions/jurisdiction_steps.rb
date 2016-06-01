Given(/^a jurisdiction "([^"]*)" exists$/) do |name|
  create :jurisdiction, name: name
end

Then /^I may( not)? (create|update|destroy) jurisdictions$/ do |negate, action|
  method = ( negate ? :not_to : :to )
  visit('/')
  click_link 'Jurisdictions'
  case action
  when 'create'
    expect( page ).send method, have_xpath('//a[contains(.,"Add Jurisdiction")]')
  when 'update'
    expect( page ).send method, have_xpath('//a[contains(.,"Settings")]')
  when 'destroy'
    expect( page ).send method, have_xpath('//a[contains(.,"Remove")]')
  end
end

Given(/^I go to add a jurisdiction$/) do
  visit '/'
  click_link 'Jurisdictions'
  find(:xpath,'//a[contains(.,"Add Jurisdiction")]').click
end

When(/^I add(?:ed)? a jurisdiction$/) do
  step %{I go to add a jurisdiction}
  fill_in 'Name', with: "Broome County"
  fill_in 'Legislative Body', with: "Broome County Legislature"
  find(:xpath,'//label[contains(.,"Executive Review Required")]').click
  find(:xpath,'//button[contains(.,"Add Jurisdiction")]').click
end

Then(/^I should see the jurisdiction was added$/) do
  expect( page ).to have_text "Jurisdiction was added."
  click_link "Jurisdictions"
  within( :xpath, '//tbody/tr[contains(./td,"Broome County")]' ) do
    find( :xpath, './/a[contains(.,"Settings")]' ).click
  end
  expect( find_field('Name').value ).to eql "Broome County"
  expect( find_field('Legislative Body').value ).to eql "Broome County Legislature"
  expect( page ).to have_selector( :active_label, "Executive Review Required" )
end

Then(/^the jurisdiction should( not)? be recorded in the database$/) do |no|
  expect( Jurisdiction.count ).to eql( no.blank? ? 1 : 0 )
end

When(/^I remove the jurisdiction$/) do
  click_link "Jurisdictions"
  find(:xpath,'//a[contains(.,"Remove")]').click
end

Then(/^I should see the jurisdiction was removed$/) do
  expect( page ).to have_text "Jurisdiction was removed."
end

When(/^I edit the jurisdiction settings$/) do
  click_link "Jurisdictions"
  find(:xpath,'//a[contains(.,"Settings")]').click
  fill_in "Name", with: "Tompkins County"
  fill_in 'Legislative Body', with: "Tompkins County Legislature"
  find(:xpath,'//label[contains(.,"No Executive Review")]').click
  find(:xpath,'//button[contains(.,"Update Jurisdiction Settings")]').click
end

Then(/^I should see the jurisdiction settings were updated$/) do
  expect( page ).to have_text "Jurisdiction settings were updated."
end

When /^I go to edit the jurisdiction settings for "([^"]+)"$/ do |name|
  step %{I click "Settings" for "#{name}"}
  expect( page ).to have_text "Edit Jurisdiction Settings"
end

Then(/^the jurisdiction settings should be updated$/) do
  expect( page ).to have_text 'Jurisdiction settings were updated.'
  step %{I go to edit the jurisdiction settings for "Tompkins County"}
  expect( find_field('Name').value ).to eql "Tompkins County"
  expect( find_field('Legislative Body').value ).to eql "Tompkins County Legislature"
  expect( page ).to have_selector( :active_label, "No Executive Review" )
end

Given(/^a jurisdiction exists$/) do
  @jurisdiction = create(:jurisdiction)
end
