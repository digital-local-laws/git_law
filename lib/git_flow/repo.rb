module GitFlow
  module Repo
    def repo_path
      raise "#{self.class.to_s} not yet persisted" unless persisted? || destroyed?
      File.join self.class.repo_root, "#{id}.git"
    end

    # Has the repo been initialized yet?
    def repo?
      File.exist? repo_path
    end

    def working_repo_path
      raise "#{self.class.to_s} not yet persisted" unless persisted? || destroyed?
      File.join self.class.working_repo_root, id.to_s
    end

    # Has the working repo been initialized yet?
    def working_repo?
      File.exist? working_repo_path
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
      return @working_repo unless @working_repo.nil?
      path = working_repo_path
      # Instantiate working_repo reference if already exists
      return @working_repo = Git.open( path ) if File.exist? path
      # Otherwise, we need to create the working directory
      create_working_repo
      @working_repo
    end

    # Gets path to file in working repo
    def working_file_path(file)
      File.join working_repo_path, file
    end

    def working_file(tree)
      # self.class.const_get(:WORKING_FILE_CLASS).new( self, file )
      GitFlow::WorkingFile.new self, tree
    end

    private

    def setup_git_flow_repo_job
      SetupGitFlowRepoJob.perform_later self
    end

    def remove_files_job
      RemoveFilesJob.perform_later repo_path
      RemoveFilesJob.perform_later working_repo_path
    end

    def create_repo
      run_callbacks :create_repo do
        FileUtils.mkdir_p self.class.repo_root
        @repo = Git.init repo_path, bare: true
        update_column :repo_created, true
      end
    end

    def create_working_repo
      run_callbacks :create_working_repo do
        path = working_repo_path
        FileUtils.mkdir_p path
        @working_repo = Git.init path
        update_column :working_repo_created, true
        repo
      end
    end
  end
end
