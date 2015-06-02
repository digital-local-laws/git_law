module GitFlow
  class WorkingFile
    include Comparable
    extend ActiveModel::Callbacks

    JSON_WRITE_OPTIONS = {
      indent: '  ',
      space: ' ',
      object_nl: "\n",
      array_nl: "\n"
    }

    define_model_callbacks :create, :initialize_node, :initialize_dir,
      :initialize_file, :destroy, :prepare_for_destroy, :update

    def initialize(git_flow_repo, path_in_repo)
      @git_flow_repo = git_flow_repo
      @path_in_repo = path_in_repo.gsub /^[\.\/]*/, ''
      super()
    end

    # Comparison
    # Show directories first, then sort by name
    def <=>( other )
      return -1 if directory?  && !other.directory?
      return 1 if !directory? && other.directory?
      file_name <=> other.file_name
    end

    # Check whether the file exists
    def exists?
      File.exist? absolute_path
    end

    # Initialize the file
    # Add and commit file
    def create
      run_callbacks :create do
        initialize_node
        # git_flow_repo.working_repo.commit "Add #{path_in_repo}"
        # git_flow_repo.working_repo.push
        true
      end
    end

    def initialize_node
      run_callbacks :initialize_node do
        # TODO structure is a property of only some nodes -- how do we generalize
        # TODO should nodes be able to be both a directory and a file with extension?
        if structure["dir"]
          initialize_dir
        else
          initialize_file
        end
      end
    end

    def initialize_dir
      run_callbacks :initialize_dir do
        FileUtils.mkdir absolute_path
      end
    end

    def initialize_file
      run_callbacks :initialize_file do
        FileUtils.touch absolute_path
        add_content!
      end
    end

    # Remove the node and its children
    # Commit changes
    def destroy
      run_callbacks :destroy do
        prepare_for_destroy
        # git_flow_repo.working_repo.commit "Remove #{path_in_repo}"
        # git_flow_repo.working_repo.push
        true
      end
    end

    def prepare_for_destroy
      run_callbacks :prepare_for_destroy do
        git_flow_repo.working_repo.remove absolute_path, recursive: true
      end
    end

    def update
      run_callbacks :update do
        unless File.directory?( absolute_path ) || File.binary?( absolute_path )
          write_content!
        end
        true
      end
    end

    def write_content!
      raise "Cannot write content for directory." if File.directory? absolute_path
      raise "Cannot write content for binary file." if File.binary? absolute_path
      File.open(absolute_path,'w') do |f|
        f << content
      end
    end

    def add_content!
      git_flow_repo.working_repo.add absolute_path
    end

    # Modifies content of the file
    # This will only work for regular text files
    def content=(newContent)
      @content = newContent
    end

    # Returns content of file
    # * array of file contents if directory
    # * actual content of text file
    # * false if binary file
    def content
      @content ||= if File.directory? absolute_path
        Dir.glob( File.join(absolute_path,'*') ).map { |entry|
          path = if File.basename(path_in_repo) == ''
            File.basename(entry)
          else
            File.join( path_in_repo, File.basename(entry) )
          end
          git_flow_repo.working_file path
        }.sort
      elsif File.binary? absolute_path
        false
      else
        File.open( absolute_path ).read || ""
      end
    end

    # Checks whether this file is a directory
    def directory?
      return @directory unless @directory.nil?
      @directory = File.directory? absolute_path
    end

    # Returns the file extension or 'dir' if directory
    def type
      @type ||= if directory?
        'dir'
      else
        File.extname path_in_repo
      end
    end

    def attributes=(values)
      self.content = values["content"] if values["content"]
      self.metadata = values["metadata"] if values["metadata"]
    end

    # Instantiate ordered list of ancestor nodes
    def ancestors
      return @ancestors unless @ancestors.nil?
      # Stop if this is already the root node
      return @ancestors = [self] if File.basename(path_in_repo).empty?
      # Path for parent is blank if parent is root node
      parent_path = if File.dirname(path_in_repo) == '.'
        ""
      # Otherwise it is the directory in which this node is located
      else
        File.dirname path_in_repo
      end
      parent = git_flow_repo.working_file parent_path
      @ancestors = parent.ancestors + [ self ]
    end

    # Return the path of the ancestor node
    def base_path
      ancestors.last.path_in_repo
    end

    # Return just the name of the file or blank if at repo root
    def file_name
      @file_name ||= File.basename path_in_repo
    end

    def path_in_repo; @path_in_repo; end

    def absolute_path
      @absolute_path ||= git_flow_repo.working_file_path path_in_repo
    end

    def status_file
      repo.status.map(&:last).select { |f| f.path == path_in_repo }
    end

    private

    def repo
      git_flow_repo.repo
    end

    def git_flow_repo; @git_flow_repo; end
  end
end
