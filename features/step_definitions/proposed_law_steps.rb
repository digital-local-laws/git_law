Given(/^I visit the code's page$/) do
  visit "/codes/#{@code.id}"
end

When(/^I propose a law$/) do
  find(:xpath,'//a[contains(.,"Propose a Law")]').click
  fill_in "Description", with: "Authorizing formation of Office of Chief Innovation Officer"
  find(:xpath,'//button[contains(.,"Add Proposed Law")]').click
end

Then(/^the proposed law should be added$/) do
  expect( page ).to have_text "Proposed law was added."
  expect( page ).to have_text "Authorizing formation of Office of Chief Innovation Officer"
  expect( ProposedLaw.count ).to eq 1
end

Given(/^I proposed a law$/) do
  step "I log in"
  step "a code exists"
  step "I visit the code's page"
  step "I propose a law"
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

