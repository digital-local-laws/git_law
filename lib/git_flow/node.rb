module GitFlow

  # This class represents a node in the structure of a legal document.
  # A node consists of a metadata JSON file and any other files in the same
  # directory that share the name of that metadata file but have a different
  # extension.
  class Node < WorkingFile
    include ActiveModel::Validations

    before_create :initialize_container_file, :initialize_text_file,
      :attributes_to_content
    before_update :attributes_to_content
    before_destroy :remove_child_nodes
    after_destroy :remove_text_file, :remove_container_file

    JSON_WRITE_OPTIONS = {
      indent: '  ',
      space: ' ',
      object_nl: "\n",
      array_nl: "\n"
    }

    def initialize( git_flow_repo, tree )
      super git_flow_repo, tree
    end

    # Returns textual content file associated with the node
    def text_file
      return @text_file unless @text_file.nil?
      @text_file = git_flow_repo.working_file tree_text_file
    end

    # Initialize the text file associated with this node, if applicable
    def initialize_text_file
      text_file.create if node_type && node_type["text"] && !text_file.exists?
    end

    def remove_text_file
      text_file.destroy if text_file.exists?
    end

    def container_file
      return @container_file unless @container_file.nil?
      @container_file = if parent_node && !parent_node.root?
        git_flow_repo.working_file( parent_node.tree_base )
      else
        false
      end
    end

    def child_container_file
      return @child_container_file unless @child_container_file.nil?
      @child_container_file = if !root?
        git_flow_repo.working_file( tree_base )
      else
        false
      end
    end

    def children_file
      return @children_file unless @children_file.nil?
      @children_file = if root?
        self
      else
        git_flow_repo.working_file tree_base
      end
    end

    # Initialize the directory associated with this node, if applicable
    def initialize_container_file
      container_file.create true if container_file && !container_file.exists?
    end

    def remove_container_file
      if container_file && container_file.exists? && container_file.children.empty?
        container_file.destroy
      end
    end

    def remove_child_nodes
      child_nodes.each { |node| node.destroy }
    end

    # Moves node and associated files to new tree location
    # Returns reference to the moved node
    def move( toTree )
      toNode = git_flow_repo.working_file( toTree ).node
      return false if toNode.exists?
      return false if toNode.text_file.exists?
      return false if toNode.child_container_file.exists?
      return false unless toNode.create
      newFile = super( toTree, force: true )
      if text_file.exists?
        text_file.move toNode.text_file.tree
      end
      if child_container_file.exists?
        child_container_file.move toNode.child_container_file.tree
      end
      newFile.node
    end

    # TODO destroy vs. repeal
    # Destroy should simply delete all files for this and child nodes
    # Destroy should only be an option for nodes not in current law
    # Repeal should remove content and add repeal metadata to this and child nodes
    # Repeal should only be an option for nodes in current law
    # This must be figured out before submission, so legislature votes on repeals
    # only.

    # What structure do child nodes of this node have?
    # Pulls from custom settings of this node or pulls down settings from above
    # Returns empty array when no children are supported
    def child_node_structure
      return @child_node_structure unless @child_node_structure.nil?
      @child_node_structure = if root?
        [ { "label" => "code",
            "number" => false,
            "title" => true,
            "text" => false } ]
      elsif attributes["structure"]
        attributes["structure"]
      elsif parent_node && parent_node.child_node_structure.length > 1
        parent_node.child_node_structure[1..(parent_node.child_node_structure.length - 1)]
      else
        []
      end
    end

    # Returns the allowed types for children of this node
    def allowed_child_node_types
      return @allowed_child_node_types unless @allowed_child_node_types.nil?
      @allowed_child_node_types = []
      child_node_structure.each do |type|
        @allowed_child_node_types << type
        break unless type["optional"]
      end
      allowed_child_node_types
    end

    # Returns the node types allowed for this node
    def allowed_node_types
      return @allowed_node_types unless @allowed_node_types.nil?
      @allowed_node_types = []
      node_structure.each do |type|
        @allowed_node_types << type
        break unless type["optional"]
      end
      allowed_node_types
    end

    # The type of this node
    def node_type
      return @node_type unless @node_type.nil?
      @node_type = if root?
        { title: true }
      elsif attributes["type"]
        allowed_node_types.select { |type| type["label"] == attributes["type"] }.first
      elsif allowed_node_types.length == 1
        allowed_node_types.first
      else
        false
      end
    end

    # Returns structural configuration for this node
    # If the node has no parent, it is a root-level "code"
    def node_structure
      return @node_structure unless @node_structure.nil?
      @node_structure = if parent_node && !parent_node.child_node_structure.empty?
        parent_node.child_node_structure
      else
        []
      end
    end

    def child_nodes
      return @child_nodes unless @child_nodes.nil?
      @child_nodes = if children_file.exists?
        children_file.children.select(&:is_node?).map(&:node)
      else
        []
      end
    end

    # Return ancestor nodes, including self
    def ancestor_nodes
      return @ancestor_nodes unless @ancestor_nodes.nil?
      @ancestor_nodes = if parent_node
        parent_node.ancestor_nodes << self
      else
        [ self ]
      end
    end

    # Retrieves the parent node
    def parent_node
      return @parent_node unless @parent_node.nil?
      @parent_node = if File.dirname( tree ) == '.' && !root?
        git_flow_repo.working_file( '' ).node
      elsif File.exist? absolute_parent_node_path
        git_flow_repo.working_file( tree_parent_node ).node
      else
        false
      end
      parent_node
    end

    # Retrieves the attributes of this node
    # JSON contents of node are parsed and returned as a hash
    def attributes
      return @attributes unless @attributes.nil?
      @attributes = if root?
        { "title" => "/" }
      elsif exists? || content.present?
        JSON.parse content
      else
        { }
      end
    end

    def attributes_to_content
      self.content = JSON.generate( attributes, JSON_WRITE_OPTIONS )
    end

    # Set attribute values from hash
    def attributes=(values)
      attributes.merge! values
      attributes
    end

    # What is the path to the parent node in the git repo?
    def tree_parent_node
      tree_parent + ".json"
    end

    # What is the path to the parent node in the git repo?
    def absolute_parent_node_path
      absolute_parent_path + ".json"
    end

    # What is the path to the parent directory in the git repo?
    def tree_parent
      File.dirname tree
    end

    # What is the path to the parent directory in the working directory?
    def absolute_parent_path
      File.dirname absolute_path
    end

    # In the git repo, what is the path to the node without extension?
    def tree_base
      tree.gsub File.extname( tree ), ''
    end

    # In absolute path, where is the working file for the node, without extension?
    def absolute_path_base
      absolute_path.gsub File.extname( absolute_path ), ''
    end

    # In git repo, where is the content file?
    def tree_text_file
      tree_base + ".asc"
    end
  end
end
