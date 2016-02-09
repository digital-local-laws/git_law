require 'rails_helper'

RSpec.describe AdoptedLaw, type: :model do
  let( :adopted_law ) { build :adopted_law }
  it 'should save with valid attributes' do
    adopted_law.save!
  end
end
