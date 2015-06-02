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
    # Add and commit file and any changes to metadata
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
        if structure["dir"]
          initialize_dir
        else
          initialize_file
        end
        initialize_metadata
      end
    end

    def initialize_metadata
      write_metadata!
      add_metadata!
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
    # Remove the metadata file, reference in law metadata
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
        remove_metadata
      end
    end

    def update
      run_callbacks :update do
        unless File.directory?( absolute_path ) || File.binary?( absolute_path )
          write_content!
        end
        write_metadata! unless is_metadata?
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

    def write_metadata!
      raise "Cannot write metadata for a file that is metadata." if is_metadata?
      File.open(metadata_path, 'w') do |f|
        f.write( JSON.generate( metadata, JSON_WRITE_OPTIONS ) )
      end
    end

    def add_metadata!
      git_flow_repo.working_repo.add metadata_path
    end

    # Remove the metadata file associated with the node
    def remove_metadata
      git_flow_repo.working_repo.remove( metadata_path ) if File.exist? metadata_path
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

    # Is this a metadata file?
    def is_metadata?
      type == '.json'
    end

    # Retrieve metadata for the specified file in working directory
    # Metadata are stored in a separate file with the same name and a json extension
    # Project root may not have a metadata file
    # JSON file may not have a metadata file
    def metadata
      return @metadata unless @metadata.nil?
      # Root and JSON file have no metadata
      if File.basename(path_in_repo).empty? || is_metadata?
        @metadata = false
      # Otherwise, check for metadata file
      else
        # Load metadata file if it exists
        if File.exist? metadata_path
          @metadata = JSON.parse File.read metadata_path
        # Otherwise, there is no metadata
        else
          @metadata = false
        end
      end
      # Recurse because metadata should be loaded or marked absent
      metadata
    end

    def attributes=(values)
      self.content = values["content"] if values["content"]
      self.metadata = values["metadata"] if values["metadata"]
    end

    def metadata=(values)
      @metadata = values
    end

    def metadata_path
      @metadata_path ||= File.join( File.dirname( absolute_path ),
        File.basename( absolute_path, File.extname(absolute_path) ) + ".json" )
    end

    # Gets structure applicable for a child of this node
    # Returns false if the node cannot have children
    def child_structure
      return @child_structure unless @child_structure.nil?
      # If this is the root node, contained structures are Codes
      @child_structure = if ancestors.first == self
        { "name" => "Code",
          "number" => false,
          "dir" => true,
          "file" => false }
      # If no structure is defined
      elsif ancestors[1].metadata === false
        false
      # Find the appropriate child structure from the code's structure metadata
      else
        structure = ancestors[1].metadata["structure"]
        p = ancestors.length - 2
        s = structure[p]
        return @child_structure = false if s.nil?
        # Can be a directory if it is not the last node
        s["dir"] = ( s != structure.last )
        # Can be a file if it is not a directory or if its child node is
        # optional
        s["file"] = if s["dir"]
          structure[p+1]["optional"] ? true : false
        else
          true
        end
        s ? s : false
      end
    end

    # Gets structure applicable at this working file's location
    # This describes the characteristics of this node and its peers
    def structure
      return @structure unless @structure.nil?
      @structure = if ancestors.length < 2
        false
      else
        ancestors[ ancestors.length - 2 ].child_structure
      end
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

    private

    def git_flow_repo; @git_flow_repo; end
  end
end
