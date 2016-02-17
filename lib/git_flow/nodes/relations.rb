module GitFlow
  module Nodes
    # This module provides methods that enable relations between nodes
    module Relations
      # Create a new child node of the current node, assigning it the next
      # available number
      def new_child_node( attributes )
        child_nodes.sort!
        last_node = child_nodes.last
        number = ( last_node ? last_node.attributes["number"].to_i : 0 )
        intrinsic_attributes = {
          "number" => "#{number + 1}"
        }
        node_type = allowed_child_node_types.first
        node = git_flow_repo.working_file(
          File.join( child_container_file.tree,
            GitFlow::Node.file_name( intrinsic_attributes, node_type )
          )
        ).node
        node.attributes = intrinsic_attributes.merge( attributes )
        node
      end

      # Is this node an ancestor of the node?
      def ancestor_of_node?( node )
        node.tree =~ /^#{Regexp.escape tree_base}/
      end

      # Returns child nodes and their children recursively
      def descendent_nodes
        @descendent_nodes ||= child_nodes.inject([]) do |memo, node|
          memo << node
          memo + node.descendent_nodes
        end
      end

      # Find child nodes of this node with an attribute matching this node
      def find( key, value )
        descendent_nodes.select do |node|
          if node.attributes[key]
            node.attributes[key] =~ /#{value}/
          else
            false
          end
        end
      end

      # What structure do child nodes of this node have?
      # Pulls from custom settings of this node or pulls down settings from above
      # Returns empty array when no children are supported
      def child_node_structure
        return @child_node_structure unless @child_node_structure.nil?
        @child_node_structure = compute_child_node_structure
      end

      # Compute the structure for child nodes of this node
      def compute_child_node_structure
        # Root node children are always codes
        if root?
          [ { "label" => "code",
              "number" => false,
              "title" => true,
              "text" => false } ]
        # Otherwise, check if this node defines a structure for its children
        elsif attributes["structure"]
          attributes["structure"]
        # Otherwise, compute structure from parent
        else
          compute_child_node_structure_from_parent
        end
      end

      # Where does this node appear in its parent's structure?
      # False if it does not
      def compute_child_node_index_from_parent
        # The node must have a type to check against parent structure
        if node_type
          parent_node.child_node_structure.index do |s|
            s['label'] == node_type['label']
          end
        # If not, return false -- we cannot use the parent structure
        else
          nil
        end
      end

      # Compute the child node structure from the parent
      def compute_child_node_structure_from_parent
        parent_index = compute_child_node_index_from_parent
        return [] unless parent_index
        # Child node structure starts to right of parent's child node structure
        start = parent_index + 1
        # If a child structure exists to the right of the parent's child node
        # structure, grab that for this node
        if parent_node.child_node_structure.length > start
          return parent_node.child_node_structure[
            start..(parent_node.child_node_structure.length - 1)
          ]
        # Otherwise, there is no structure from the parent to inherit
        else
          return []
        end
      end

      # Returns the allowed types for children of this node
      def allowed_child_node_types
        @allowed_child_node_types ||=
        self.class.allowed_node_types( child_node_structure )
      end

      # Returns the node types allowed for this node
      def allowed_node_types
        @allowed_node_types ||=
        self.class.allowed_node_types( node_structure )
      end

      # Returns structural configuration for this node
      # If the node has no parent, it is a root-level "code"
      def node_structure
        return @node_structure unless @node_structure.nil?
        @node_structure =
        if parent_node && !parent_node.child_node_structure.empty?
          parent_node.child_node_structure
        else
          []
        end
      end

      # Returns child nodes of this node
      def child_nodes
        return @child_nodes unless @child_nodes.nil?
        @child_nodes =
        if child_container_file && child_container_file.exists?
          child_container_file.children.select(&:is_node?).map(&:node)
        else
          []
        end
      end

      # Return ancestor nodes, including self
      def ancestor_nodes
        return @ancestor_nodes unless @ancestor_nodes.nil?
        @ancestor_nodes =
        if parent_node
          parent_node.ancestor_nodes << self
        else
          [ self ]
        end
      end

      # Retrieves the parent node
      def parent_node
        return @parent_node unless @parent_node.nil?
        @parent_node =
        if tree_parent.empty? && !root?
          git_flow_repo.working_file( '' ).node
        elsif File.exist? absolute_parent_node_path
          git_flow_repo.working_file( tree_parent_node ).node
        else
          false
        end
        parent_node
      end

    end
  end
end
