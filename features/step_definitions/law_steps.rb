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
end
