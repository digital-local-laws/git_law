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
    include GitFlow::Repo
    define_model_callbacks :create_repo, :create_working_repo
    after_create :setup_git_flow_repo_job
    after_destroy :remove_files_job
    working_file_class = if options[:working_file_class]
      options.delete :working_file_class
    else
      GitFlow::WorkingFile
    end
    const_set :WORKING_FILE_CLASS, working_file_class
  end
end
