require 'git_flow/nodes/relations'

module GitFlow

  # This class represents a node in the structure of a legal document.
  # A node consists of a metadata JSON file and any other files in the same
  # directory that share the name of that metadata file but have a different
  # extension.
  class Node < WorkingFile
    include ActiveModel::Validations
    include GitFlow::Nodes::Relations

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

    # Generate appropriate file_name for a sibling node with new attributes
    # that are different from the present node
    def self.file_name( attributes, node_type )
      name =
      if attributes["number"] && node_type && node_type["label"]
        "#{node_type['label']}-#{attributes['number']}"
      else
        attributes["title"]
      end
      name.downcase!
      name.gsub!( /[^a-z0-9]+/, '-' )
      name.gsub!( /^-/, '' )
      name.gsub!( /-$/, '' )
      "#{name}.json"
    end

    def <=>(other)
      comp = node_type["label"] <=> other.node_type["label"]
      return comp unless comp == 0
      comp = attributes["number"].to_i <=> other.attributes["number"].to_i
      return comp unless comp == 0
      attributes["title"] <=> other.attributes["title"]
    end

    def initialize( git_flow_repo, tree )
      super( git_flow_repo, tree )
    end

    def self.to_reference( tree ); tree.chomp('.json').gsub( /\// , '_' ); end

    def to_reference; self.class.to_reference tree; end

    # Takes a reference (usually to another node)
    # Returns array of the full reference and the tree
    # The tree can be used to pull up metadata for referenced node
    def to_interpolated_reference( target )
      current = tree.split("/")
      target_parts = target.split("/")
      parts = []
      while current.any? && current.first != target_parts.first do
        parts << current.shift
      end
      parts += target_parts
      target_tree = parts.join "/"
      target_node = git_flow_repo.working_file( target_tree + ".json" ).node
      if parts.length > 1
        if target_node.exists?
          [ self.class.to_reference( parts.join('/') ), target_node ]
        else
          raise "Target node does not exist (#{tree}): #{target_node.tree}"
        end
      else
        [ target ]
      end
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

    # Remove the text file associated with this node
    def remove_text_file
      text_file.destroy if text_file.exists?
    end

    # Get container file in which this node is located
    def container_file
      return @container_file unless @container_file.nil?
      @container_file =
      if parent_node && !parent_node.root?
        git_flow_repo.working_file( parent_node.tree_base )
      else
        false
      end
    end

    # Get the working file where children of this node are located
    def child_container_file
      return @child_container_file unless @child_container_file.nil?
      @child_container_file =
      if !root?
        git_flow_repo.working_file( tree_base )
      else
        git_flow_repo.working_file( '' )
      end
    end

    # Initialize the directory in which this node is placed, if applicable
    def initialize_container_file
      container_file.create true if container_file && !container_file.exists?
    end

    # Removes the container directory for this node, if applicable
    def remove_container_file
      if container_file && container_file.exists? && container_file.children.empty?
        container_file.destroy
      end
    end

    # Removes child nodes of this node
    def remove_child_nodes
      child_nodes.each { |node| node.destroy }
    end

    # Moves node and associated files to new tree location
    # Returns reference to the moved node
    def move( to_tree )
      to_node = move_to_node( to_tree )
      return false unless to_node
      new_file = super( to_tree, force: true )
      if text_file.exists?
        text_file.move to_node.text_file.tree, force: true
      end
      if child_container_file.exists?
        child_container_file.move to_node.child_container_file.tree
      end
      new_file.node
    end

    # Set up the node to which this node is being moved
    def move_to_node( to_tree )
      to_node = git_flow_repo.working_file( to_tree ).node
      return false if to_node.exists?
      return false if to_node.text_file.exists?
      return false if to_node.child_container_file.exists?
      return false unless to_node.create
      to_node
    end

    # TODO destroy vs. repeal
    # Destroy should simply delete all files for this and child nodes
    # Destroy should only be an option for nodes not in current law
    # Repeal should remove content and add repeal metadata to this and child nodes
    # Repeal should only be an option for nodes in current law
    # This must be figured out before submission, so legislature votes on repeals
    # only.

    # Given an array representing structure of a node, return the members that
    # are allowed as children
    # This will return the first entry if it is not optional
    # Otherwise, it will continue until it reaches the end of the structure
    # or a required level
    def self.allowed_node_types( structure )
      out = []
      structure.each do |type|
        out << type
        break unless type['optional']
      end
      out
    end

    # The type of this node
    def node_type
      return @node_type unless @node_type.nil?
      @node_type =
      if root?
        { title: true }
      elsif attributes["type"]
        allowed_node_types.find { |type| type["label"] == attributes["type"] }
      elsif allowed_node_types.length == 1
        allowed_node_types.first
      else
        false
      end
    end

    # Get the properly formatted number for this node
    def node_number
      return unless node_type && attributes["number"]
      number = attributes["number"].to_i
      case node_type["number"]
      when 'R'
        number.to_roman
      when 'r'
        number.to_roman.downcase
      when 'A'
        number.to_alpha.upcase
      when 'a'
        number.to_alpha
      else
        number
      end
    end

    # Render the label for the node type
    def node_label
      node_type['label']
    end

    # Render the full title of the node
    def node_title
      title = node_number ? "#{node_label.capitalize} #{node_number}. " : ""
      title = "#{title}#{attributes['title']}" if attributes['title']
      title
    end

    # Short title for node
    def node_short_title
      if node_number
        "#{node_label.capitalize} #{node_number}"
      else
        "#{attributes['title']}"
      end
    end

    # Render titles of parent nodes
    def node_title_context
      ancestor_nodes.reject(&:root?).reject { |ancestor|
        ancestor.tree == tree
      }.map(&:node_short_title).join(', ')
    end

    # Retrieves the attributes of this node
    # JSON contents of node are parsed and returned as a hash
    def attributes
      return @attributes unless @attributes.nil?
      @attributes =
      if root?
        { "title" => "/" }
      elsif exists? || content.present?
        JSON.parse content
      else
        { }
      end
    end

    # Recursive sorting algorithm for hash, array, value nest structures
    def self.sorted_attributes(attributes)
      if attributes.is_a? Hash
        attributes.keys.sort.inject({}) do |memo, key|
          memo[key] = sorted_attributes( attributes[key] )
          memo
        end
      elsif attributes.is_a? Array
        # Do not sort an array if the entries are not comparable
        attributes.each do |attribute|
          unless attribute.class.included_modules.include? Comparable
            return attributes.map { |value| sorted_attributes( value ) }
          end
        end
        attributes.sort.map { |value| sorted_attributes( value ) }
      else
        attributes
      end
    end

    # Returns attributes sorted
    # Useful for writing attributes to JSON in predictable order
    def sorted_attributes
      self.class.sorted_attributes attributes
    end

    # Returns sorted_attributes as JSON content suitable to write to file
    def attributes_to_content
      self.content = JSON.generate( sorted_attributes, JSON_WRITE_OPTIONS )
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
      return @tree_parent if @tree_parent
      @tree_parent = File.dirname tree
      @tree_parent = '' if @tree_parent == '.'
      tree_parent
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

    # Compile node and children using specified compiler
    # If no base is specified, create a base in the build location root
    def compile(compiler_type)
      compiler =
      case compiler_type
      when :node
        GitLaw::Compilers::NodeCompiler
      else
        raise ArgumentError, "Unsupported compiler type: #{compiler_type}"
      end
      compiler.new( self )
    end
  end
end
