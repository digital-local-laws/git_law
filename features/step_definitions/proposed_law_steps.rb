Given(/^I visit the jurisdiction's page$/) do
  visit "/jurisdictions/#{@jurisdiction.id}"
end

When(/^I propose a law$/) do
  find(:xpath,'//a[contains(.,"Propose a Law")]').click
  fill_in "Title", with: "Authorizing formation of Office of Chief Innovation Officer"
  find(:xpath,'//button[contains(.,"Add Proposed Law")]').click
end

Then(/^the proposed law should be added$/) do
  expect( page ).to have_text "Proposed law was added."
  expect( page ).to have_text "Authorizing formation of Office of Chief Innovation Officer"
  expect( ProposedLaw.count ).to eq 1
end

Given(/^I proposed a law$/) do
  step "a jurisdiction exists"
  step "I log in"
  step "I visit the jurisdiction's page"
  step "I propose a law"
  expect( page ).to have_text 'Proposed law was added.'
  @proposed_law = ProposedLaw.first
end

When(/^I remove the proposed law$/) do
  find(:xpath,'//a[contains(.,"Remove")]').click
end

Then(/^I should see the proposed law was removed$/) do
  expect( page ).to have_text "Proposed law was removed."
end

Then(/^the proposed law should not be recorded in the database$/) do
  expect( ProposedLaw.count ).to eq 0
end

When(/^I edit the proposed law settings$/) do
  find(:xpath,'//a[contains(.,"Settings")]').click
  fill_in "Title", with: "Authorizing formation of Office of Chief Obstructionist"
  find(:xpath,'//button[contains(.,"Update Proposed Law Settings")]').click
end

Then(/^the proposed law settings should be updated$/) do
  expect( page ).to have_text "Proposed law settings were updated."
  expect( page ).to have_text "Authorizing formation of Office of Chief Obstructionist"
  expect( ProposedLaw.first.title ).to eq "Authorizing formation of Office of Chief Obstructionist"
end

When(/^I go to edit the proposed law$/) do
  click_link "#{@proposed_law.title}"
end

When(/^I add a section$/) do
  click_button "Add Section"
  fill_in "Title", with: "Purpose"
  click_button "Add Section"
end

Then(/^the section should be added$/) do
  expect( page ).to have_text "Section 1. Purpose"
end
