class Code < ActiveRecord::Base
  has_many :proposed_laws, dependent: :restrict_with_error,
    inverse_of: :code
  
  validates :name, presence: true, uniqueness: true
  validates :file_name, presence: true, uniqueness: true
  
  before_validation :set_file_name
  
  acts_as_git_flow_repo
  
  after_create_working_directory :initialize_working_directory
  
  private
  
  def initialize_working_directory
    # Try to fast-forward to origin/master
    if working_directory.branches['origin/master']
      working_directory.pull 'origin', 'master'
    # Otherwise, make stub commit and push to origin/master
    else
      FileUtils.cp_r "#{::Rails.root}/lib/assets/code", working_directory_path
      working_directory.add '.'
      working_directory.commit 'Set up initial stub for legislation.'
      working_directory.push 'origin', 'master'
    end
  end
  
  def set_file_name
    return unless name
    self.file_name = name.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').
      gsub(/^-/,'').gsub(/-$/,'')
  end  
end
