class ActiveRecord::Base
  def self.acts_as_git_flow_repo(options = {})
    cattr_accessor :repos_root
    self.repos_root = (options[:repos_root] ||
      "#{::Rails.root}/db/#{::Rails.env}/repos")
    cattr_accessor :repo_root_part
    self.repo_root_part = (options[:repo_root_part] ||
      to_s.underscore)
    define_singleton_method(:repo_root) do
      "#{repos_root}/#{repo_root_part}"
    end
    include GitFlowRepo
  end
end

module GitFlowRepo
  def repo_path
    raise "#{self.class.to_s} not yet persisted" unless persisted?
    "#{Code.repo_root}/#{id}.git"
  end
  
  def working_directory_path
    raise "#{self.class.to_s} not yet persisted" unless persisted?
    "#{Code.repos_root}/codes_working/#{id}"
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
    working_directory.add_remote 'origin', repo_path
    # Try to fast-forward to origin/master
    if working_directory.branches['origin/master']
      working_directory.pull 'origin', 'master'
    # Otherwise, make stub commit and push to origin/master
    else
      FileUtils.cp_r "#{::Rails.root}/lib/assets/code", path
      working_directory.add '.'
      working_directory.commit 'Set up initial stub for legislation.'
      working_directory.push 'origin', 'master'
    end
    working_directory
  end
end
