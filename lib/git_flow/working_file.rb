module GitFlow
  class WorkingFile
    include Comparable
    extend ActiveModel::Callbacks

    define_model_callbacks :create, :update, :destroy

    def initialize(git_flow_repo, tree)
      @git_flow_repo = git_flow_repo
      @tree = tree.gsub /^[\.\/]*/, ''
      super()
    end

    # Comparison by file name
    def <=>( other )
      tree <=> other.tree
    end

    # Check whether the file exists
    def exists?
      File.exist? absolute_path
    end

    # Retrieves the children of this folder, if it is a directory
    # Children are instantiated as working files
    # Returns false if it is not a directory
    def children
      return @children unless @children.nil?
      @children = if exists? && directory?
        Dir.glob( File.join(absolute_path,'*') ).sort.map do |entry|
          git_flow_repo.working_file(
            entry.gsub( /^#{Regexp.escape absolute_path}/, tree )
          )
        end
      else
        false
      end
    end

    def is_node?
      file_name =~ /\.json$/
    end

    # Instantiates a node object for this file, if it is a node file
    def node
      if root?
        GitFlow::Node.new git_flow_repo, tree
      elsif is_node?
        GitFlow::Node.new git_flow_repo, tree
      else
        false
      end
    end

    # Save the file
    def save
      if exists?
        update
      else
        create
      end
    end

    # Initialize the file
    def create( directory = false )
      run_callbacks :create do
        if directory
          FileUtils.mkdir absolute_path
        else
          write_content
        end
        true
      end
    end

    # Write content to the file
    def write_content
      File.open(absolute_path,'w') do |file|
        file << content if content
      end
    end

    # Set content to be stored in the file
    def content=(v)
      @content = v
    end

    # Access content from file
    def content
      return @content unless @content.nil?
      @content = if exists?
        File.read absolute_path
      else
        false
      end
    end

    def update
      run_callbacks :update do
        write_content
        true
      end
    end

    # Remove the node and its children
    # Commit changes
    def destroy
      run_callbacks :destroy do
        if directory?
          FileUtils.rmdir absolute_path
        else
          FileUtils.rm absolute_path
        end
        true
      end
    end

    # Checks whether this file is a directory
    def directory?
      return @directory unless @directory.nil?
      @directory = File.directory? absolute_path
    end

    # Instantiate ordered list of ancestor nodes
    def ancestors
      return @ancestors unless @ancestors.nil?
      # Stop if this is already the root node
      return @ancestors = [self] if File.basename(tree).empty?
      # Path for parent is blank if parent is root node
      parent_path = if File.dirname(tree) == '.'
        ""
      # Otherwise it is the directory in which this node is located
      else
        File.dirname tree
      end
      parent = git_flow_repo.working_file parent_path
      @ancestors = parent.ancestors + [ self ]
    end

    # Return just the name of the file or blank if at repo root
    def file_name
      @file_name ||= File.basename tree
    end

    def file_name_extension
      File.extname tree
    end

    def tree; @tree; end

    def absolute_path
      @absolute_path ||= git_flow_repo.working_file_path tree
    end

    def status_file
      repo.status.map(&:last).select { |f| f.path == tree }
    end

    def root?
      tree == ''
    end

    private

    def repo
      git_flow_repo.repo
    end

    def git_flow_repo; @git_flow_repo; end
  end
end
