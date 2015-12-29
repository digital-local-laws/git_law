module GitLaw
  module Compilers
    class NodeCompiler < GitLaw::Compiler
      attr_accessor :node

      def initialize( node )
        super( node )
      end

      def compile
        out << "[[#{reference}]]\n"
        out << "#{'='*level} #{title}\n"
        # Add document-level metadata for a root node
        if level == 1
          out << ":doctype: book\n"
          out << ":!sectnums:\n"
        end
        out << "\n"
        unless content.empty?
          out << "#{content}\n\n"
        end
        out << "// tag::#{reference}_content[]\n\n"
        node.child_nodes.each do |child|
          child_compiler = child.compile(:node).compile
          out << "include::#{node.child_container_file.file_name}/#{child.text_file.file_name}[]\n\n"
        end
        out << "// end::#{reference}_content[]\n"
        close
      end

      def content
        @content ||= if node.text_file.exists?
          parse_content( node.text_file.content )
        else
          ""
        end
      end

      def parse_content(content)
        # Interpolate the links
        content.gsub( /<<([^\/]+[\/][^,]+)(,[^>]+)?>>/ ) do |match|
          ref = node.to_interpolated_reference $1
          if $2 || ref.length < 2
            "<<#{ref[0]}#{$2}>>"
          elsif ref[1].ancestor_nodes.reject(&:root?).any?
            "<<#{ref[0]},#{ref[1].node.node_title}>> of #{ref[1].node_title_context}"
          else
            "<<#{ref[0]},#{ref[1].node.node_title}>>"
          end
        end
      end

      def reference
        @reference ||= node.to_reference
      end

      def type
        @type ||= node.node_type
      end

      def level
        @level ||= node.tree.split("/").count
      end

      def label
        @label ||= node.node_label
      end

      def title
        @title ||= node.node_title
      end

      def number
        return @number unless @number.nil?
        @number = type["number"] ? node.attributes["number"] : false
      end
    end
  end
end
