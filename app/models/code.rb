class Code < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :file_name, presence: true, uniqueness: true
  
  before_validation :set_file_name
  
  def self.repos_root
    "#{::Rails.root}/db/#{::Rails.env}"
  end
  
  def self.repo_root
    "#{repos_root}/codes"
  end
  
  def repo_path
    raise "Code not yet persisted" unless persisted?
    "#{Code.repo_root}/#{id}.git"
  end
  
  def working_directory_path
    raise "Code not yet persisted" unless persisted?
    "#{Code.repos_root}/codes_working/#{id}.git"
  end
  
  # Returns reference to canonical repository for the code
  def repo
    # Return repo reference if already available
    return @repo if @repo
    # Instantiate repo reference if already exists
    path = repo_path
    return @repo = Git.open( path ) if File.exist? path
    # Otherwise, we need to create the repo
    FileUtils.mkdir_p Code.repo_root
    @repo = Git.init path, bare: true
  end
  
  # Returns reference to working directory which tracks the canonical repository
  def working_directory
    # Return working_directory reference if already available
    return @working_directory if @working_directory
    path = working_directory_path
    # Instantiate working_directory reference if already exists
    return @working_directory = Git.open( path ) if File.exist? path
    # Otherwise, we need to create the working directory
    FileUtils.mkdir_p path
    @working_directory = Git.init path
    repo
    working_directory.add_remote repo_path, 'origin'
    # Try to fast-forward to origin/master
    origin_master = working_directory.branches.remote[:master]
    if origin_master
      working_directory.pull origin_master
    # Otherwise, make stub commit and push to origin/master
    else
      FileUtils.cp_r "#{::Rails.root}/lib/assets/code", path
      working_directory.add '.'
      working_directory.commit 'Set up initial stub for legislation.'
    end
    working_directory
  end

  private
  
  def set_file_name
    return unless name
    self.file_name = name.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').
      gsub(/^-/,'').gsub(/-$/,'')
  end  
end
