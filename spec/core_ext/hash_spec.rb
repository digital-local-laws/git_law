require 'rails_helper'

RSpec.describe Hash do
  let (:decamel) {
    {
      "a_key" => [
          { "another_key" => "value" },
          { "yet_another_key" => "value" }
      ]
    }
  }

  let (:camel) {
    {
      "aKey" => [
        { "anotherKey" => "value" },
        { "yetAnotherKey" => "value" }
      ]
    }
  }

  it 'should start with different camelized and decamelized hashes' do
    expect( camel ).not_to eql decamel
  end

  it 'should camelize correctly' do
    decamel.camelize!
    expect( decamel ).to eql camel
  end

  it 'shoud decamelize correctly' do
    camel.decamelize!
    expect( camel ).to eql decamel
  end
end
