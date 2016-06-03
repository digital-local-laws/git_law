class Jurisdiction < ActiveRecord::Base
  has_many :proposed_laws, dependent: :restrict_with_error,
    inverse_of: :jurisdiction
  has_many :jurisdiction_memberships, dependent: :delete_all,
    inverse_of: :jurisdiction
  has_many :users, through: :jurisdiction_memberships

  validates :name, presence: true, uniqueness: true
  validates :file_name, presence: true, uniqueness: true
  validates :executive_review, inclusion: { in: [ true, false ] }
  validates :government_type, inclusion: { in: %w( city county town village ) }
  validates :legislative_body, presence: true

  before_validation :set_file_name

  acts_as_git_flow_repo

  after_create_working_repo :initialize_working_repo

  private

  def initialize_working_repo
    # Track the public-facing canonical repo
    working_repo.add_remote 'origin', repo_path
    working_repo
    # Try to fast-forward to origin/master
    if working_repo.branches['origin/master']
      working_repo.pull 'origin', 'master'
    # Otherwise, make stub commit and push to origin/master
    else
      FileUtils.cp_r Dir.glob("#{::Rails.root}/lib/assets/jurisdiction/*"), working_repo_path
      working_repo.add '.'
      working_repo.commit 'Set up initial stub for legislation.'
      working_repo.push 'origin', 'master'
    end
  end

  def set_file_name
    return unless name
    self.file_name = name.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').
      gsub(/^-/,'').gsub(/-$/,'')
  end
end
