class Code < ActiveRecord::Base
  has_many :proposed_laws, dependent: :restrict_with_error,
    inverse_of: :code
  
  validates :name, presence: true, uniqueness: true
  validates :file_name, presence: true, uniqueness: true
  
  before_validation :set_file_name
  
  acts_as_git_flow_repo
  
  private
  
  def set_file_name
    return unless name
    self.file_name = name.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').
      gsub(/^-/,'').gsub(/-$/,'')
  end  
end
