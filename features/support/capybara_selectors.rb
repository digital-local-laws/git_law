Capybara.add_selector(:user_row) do
  xpath do |name|
    names = if name.is_a? Array
      name
    else
      name.split ' '
    end
    ".//tbody/tr[ ./td[position()=1 and contains(.,'#{names.first}')] " +
    "and ./td[position()=2 and contains(.,'#{names.last}')] ]"
  end
end
