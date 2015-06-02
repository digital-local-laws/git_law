Given(/^I visit the jurisdiction's page$/) do
  visit "/jurisdictions/#{@jurisdiction.id}"
end

When(/^I propose a law$/) do
  find(:xpath,'//a[contains(.,"Propose a Law")]').click
  fill_in "Title", with: "Authorizing formation of Office of Chief Innovation Officer"
  find(:xpath,'//button[contains(.,"Add Proposed Law")]').click
end

Then(/^the proposed law should be added$/) do
  # TODO how do we see what's going on while timeout loop is running?
  # expect( page ).to have_text "Authorizing formation of Office of Chief Innovation Officer"
  # expect( page ).to have_text "Please wait while the proposed law is initialized."
  step "all jobs have run"
  sleep 2
  expect( current_url ).to match /\/browse\/$/
  expect( ProposedLaw.count ).to eq 1
end

Given(/^I proposed a law$/) do
  step "a jurisdiction exists"
  step "I log in"
  step "I visit the jurisdiction's page"
  step "I propose a law"
  # TODO how to detect intermediate state when angular is unresolved because of timeout loop?
  # expect( page ).to have_text "Please wait while the proposed law is initialized."
  step "all jobs have run"
  @proposed_law = ProposedLaw.first
  click_link @proposed_law.jurisdiction.name
end

When(/^I remove the proposed law$/) do
  click_link @proposed_law.jurisdiction.name
  find(:xpath,'//a[contains(.,"Remove")]').click
end

Then(/^I should see the proposed law was removed$/) do
  expect( page ).to have_text "Proposed law was removed."
end

Then(/^the proposed law should not be recorded in the database$/) do
  expect( ProposedLaw.count ).to eq 0
end

When(/^I edit the proposed law settings$/) do
  click_link @proposed_law.jurisdiction.name
  find(:xpath,'//a[contains(.,"Settings")]').click
  fill_in "Title", with: "Authorizing formation of Office of Chief Obstructionist"
  find(:xpath,'//button[contains(.,"Update Proposed Law Settings")]').click
end

Then(/^the proposed law settings should be updated$/) do
  expect( page ).to have_text "Proposed law settings were updated."
  expect( page ).to have_text "Authorizing formation of Office of Chief Obstructionist"
  expect( ProposedLaw.first.title ).to eq "Authorizing formation of Office of Chief Obstructionist"
end

When(/^I go to browse the proposed law$/) do
  within(:xpath,"//td[contains(.,\"#{@proposed_law.title}\")]") do
    find(:xpath,"//a[contains(.,\"#{@proposed_law.title}\")]").click
  end
end

When(/^I add a code$/) do
  find( :xpath, '//button[contains(.,"Add Code")]' ).click
  fill_in "Title", with: "Tompkins County Code"
  within( :xpath, "//fieldset[contains(./legend,\"Level 1\")]" ) do
    fill_in "Name", with: "Part"
    select "Upper case roman (I, II, ...)", from: "Number"
    find( :xpath, '//label[contains(.,"Allow Title")]' ).click
    find( :xpath, '//label[contains(.,"Is Not Optional")]' ).click
  end
  within(".modal-footer") do
    click_button "Add Code"
  end
end

Then(/^the code should be added$/) do
  expect( page ).to have_text "tompkins-county-code"
end
