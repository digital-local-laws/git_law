Then(/^I may( not)? go to administration$/) do |no|
  visit '/'
  within(".nav") do
    if no
      expect( page ).to have_no_text "Administration"
    else
      expect( page ).to have_text "Administration"
    end
  end
end

When /^I click "([^"]+)" for "([^"]+)"$/ do |button, name|
  within( :xpath, "//tbody/tr[contains(./td,'#{name}')]" ) do
    find( :xpath, ".//a[contains(.,'#{button}')]" ).click
  end
end
