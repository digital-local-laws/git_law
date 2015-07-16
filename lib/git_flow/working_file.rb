module GitFlow
  class WorkingFile
    class Transaction
      def close( message )
        # TODO commit the Transaction
        # TODO free resources
      end
    end
    include Comparable
    extend ActiveModel::Callbacks

    define_model_callbacks :create, :update, :destroy, :move

    after_create :add

    cattr_accessor :top_transaction



    # Encapsulates block of code in Git transaction
    def self.transaction(message)
      transaction = Transaction.new unless top_transaction
      top_transaction ||= transaction
      begin
        yield
        transaction.close message
      rescue
        # TODO should we track the files this transaction touches and
        # do a checkout of each one to reset it to the HEAD state?
      end
    end

    # Add the file to the index
    def add
      working_repo.add tree
    end

    def logger; Rails.logger; end

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
        git_flow_repo.working_file_node_class.new git_flow_repo, tree
      elsif is_node?
        git_flow_repo.working_file_node_class.new git_flow_repo, tree
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
          logger.info "Create directory at #{absolute_path}"
          FileUtils.mkdir absolute_path
        else
          logger.info "Create file at #{absolute_path}"
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
      # TODO git functionality
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
        logger.info "Update file at #{absolute_path}"
        write_content
        true
      end
    end

    # Rename a file
    def move(to_tree,options={})
      run_callbacks :move do
        new_file = git_flow_repo.working_file( to_tree )
        force = options.delete :force
        return false if new_file.exists? && !force
        logger.info "Move #{absolute_path} to #{new_file.absolute_path}"
        # If a directory, make new directory, move all children, remove old
        if directory?
          FileUtils.mkdir new_file.absolute_path
          children.each do |child|
            child.move child.tree.gsub( /^#{Regexp.escape tree}/, to_tree )
          end
          FileUtils.rmdir absolute_path
        else
          FileUtils.mv absolute_path, new_file.absolute_path
          new_file.add
          remove
        end
        git_flow_repo.working_file( to_tree )
      end
    end

    # Remove the node and its children
    # Commit changes
    def destroy
      run_callbacks :destroy do
        if directory?
          logger.info "Delete directory at #{absolute_path}"
          FileUtils.rmdir absolute_path
        else
          logger.info "Delete file at #{absolute_path}"
        # TODO if the file has added state (not committed), reset it to HEAD
          if status_file.untracked?
            FileUtils.rm absolute_path
          else
            remove
          end
        end
        true
      end
    end

    # Remove file from working directory and stage deletion from the index
    def remove
      working_repo.remove tree
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
      matches = working_repo.status.map.select { |f| f.path == tree }
      matches.first
    end

    def root?
      tree == ''
    end

    private

    def repo
      git_flow_repo.repo
    end

    def working_repo; git_flow_repo.working_repo; end

    def git_flow_repo; @git_flow_repo; end
  end
end
