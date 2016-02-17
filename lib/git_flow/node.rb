require 'git_flow/nodes/assets'
require 'git_flow/nodes/attributes'
require 'git_flow/nodes/relations'

module GitFlow

  # This class represents a node in the structure of a legal document.
  # A node consists of a metadata JSON file and any other files in the same
  # directory that share the name of that metadata file but have a different
  # extension.
  class Node < WorkingFile
    include ActiveModel::Validations

    include GitFlow::Nodes::Assets
    extend GitFlow::Nodes::Attributes::ClassMethods
    include GitFlow::Nodes::Attributes::InstanceMethods
    include GitFlow::Nodes::Relations

    before_create :initialize_container_file, :initialize_text_file,
      :attributes_to_content
    before_update :attributes_to_content
    before_destroy :remove_child_nodes
    after_destroy :remove_text_file, :remove_container_file

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
