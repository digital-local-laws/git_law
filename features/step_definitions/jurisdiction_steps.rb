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
  within(".modal-body") do
    fill_in 'Name', with: "Tompkins County"
    find(:xpath,'//button[contains(.,"Add Jurisdiction")]').click
  end
end

Then(/^I should see the jurisdiction was added$/) do
  expect( page ).to have_text "Jurisdiction was added."
  within(:xpath,'//tbody/tr/td[position()=1]') do
    # TODO - how do we want to identify these jurisdictions?
    expect(page).to have_text "Tompkins County"
  end
end

Then(/^the jurisdiction should( not)? be recorded in the database$/) do |no|
  expect( Jurisdiction.count ).to eql( no.blank? ? 1 : 0 )
end

When(/^I remove the jurisdiction$/) do
  find(:xpath,'//a[contains(.,"Remove")]').click
end

Then(/^I should see the jurisdiction was removed$/) do
  expect( page ).to have_text "Jurisdiction was removed."
end

When(/^I edit the jurisdiction settings$/) do
  find(:xpath,'//a[contains(.,"Settings")]').click
  within(".modal-body") do
    fill_in "Name", with: "Tompkins County"
    find(:xpath,'//button[contains(.,"Update Jurisdiction Settings")]').click
  end
end

Then(/^I should see the jurisdiction settings were updated$/) do
  expect( page ).to have_text "Jurisdiction settings were updated."
end

Then(/^the jurisdiction settings should be updated$/) do
  within("tbody") do
    expect( page ).to have_text "Tompkins County"
    expect( Jurisdiction.first.name ).to eql "Tompkins County"
  end
end

Given(/^a jurisdiction exists$/) do
  @jurisdiction = create(:jurisdiction)
end
