class ProposedLaw < ActiveRecord::Base
  belongs_to :code
  belongs_to :user
  validates :title, presence: true
end
