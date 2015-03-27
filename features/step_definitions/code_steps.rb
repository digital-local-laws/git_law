Given(/^I go to add a code$/) do
  visit '/'
  click_link 'Codes'
  find(:xpath,'//a[contains(.,"Add Code")]').click
end

When(/^I add(?:ed)? a code$/) do
  step %{I go to add a code}
  within(".modal-body") do
    fill_in :name, with: "Tompkins Code"
    find(:xpath,'//button[contains(.,"Add Code")]').click
  end
end

Then(/^I should see the code was added$/) do
  expect( page ).to have_text "Code was added."
  within(:xpath,'//tbody/tr/td[position()=1]') do
    # TODO - how do we want to identify these codes?
    expect(page).to have_text "Tompkins Code"
  end
end

Then(/^the code should( not)? be recorded in the database$/) do |no|
  expect( Code.count ).to eql( no.blank? ? 1 : 0 )
end

When(/^I remove the code$/) do
  find(:xpath,'//a[contains(.,"Remove")]').click
end

Then(/^I should see the code was removed$/) do
  expect( page ).to have_text "Code was removed."
end

When(/^I edit the code settings$/) do
  find(:xpath,'//a[contains(.,"Settings")]').click
  within(".modal-body") do
    fill_in "Name", with: "Tompkins County Code"
    find(:xpath,'//button[contains(.,"Update Code Settings")]').click
  end
end

Then(/^I should see the code settings were updated$/) do
  expect( page ).to have_text "Code settings were updated."
end

Then(/^the code settings should be updated$/) do
  within("tbody") do
    expect( page ).to have_text "Tompkins County Code"
    expect( Code.first.name ).to eql "Tompkins County Code"
  end
end

Given(/^a code exists$/) do
  @code = create(:code)
end
