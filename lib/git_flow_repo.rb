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
    cattr_accessor :working_repo_root_part
    self.working_repo_root_part = (options[:working_repo_root_part] ||
      "working_#{to_s.underscore}")
    define_singleton_method(:working_repo_root) do
      "#{repos_root}/#{working_repo_root_part}"
    end
    include GitFlowRepo
    define_model_callbacks :create_repo, :create_working_repo
  end
end

module GitFlowRepo
  def repo_path
    raise "#{self.class.to_s} not yet persisted" unless persisted?
    "#{self.class.repo_root}/#{id}.git"
  end
  
  def working_repo_path
    raise "#{self.class.to_s} not yet persisted" unless persisted?
    "#{self.class.working_repo_root}/#{id}"
  end
  
  # Returns reference to public repository
  def repo
    # Return repo reference if already available
    return @repo if @repo
    # Instantiate repo reference if already exists
    path = repo_path
    return @repo = Git.open( path ) if File.exist? path
    # Otherwise, we need to create the repo
    create_repo
  end
  
  # Returns reference to working repo which tracks the canonical repository
  def working_repo
    # Return working_repo reference if already available
    return @working_repo if @working_repo
    path = working_repo_path
    # Instantiate working_repo reference if already exists
    return @working_repo = Git.open( path ) if File.exist? path
    # Otherwise, we need to create the working directory
    create_working_repo
  end
  
  private
  
  def create_repo
    run_callbacks :create_repo do
      FileUtils.mkdir_p self.class.repo_root
      @repo = Git.init repo_path, bare: true
    end
  end
  
  def create_working_repo
    run_callbacks :create_working_repo do
      path = working_repo_path
      FileUtils.mkdir_p path
      @working_repo = Git.init path
      repo
      working_repo.add_remote 'origin', repo_path
      working_repo
    end
  end
end