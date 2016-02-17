module GitFlow
  module Nodes
    # This module includes methods for computing the location of and accessing
    # file assets associated with the node
    module Assets

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

    end
  end
end
