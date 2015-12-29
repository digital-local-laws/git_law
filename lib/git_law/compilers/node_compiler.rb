module GitLaw
  module Compilers
    class NodeCompiler < GitLaw::Compiler
      attr_accessor :node

      def initialize( node )
        super( node )
      end

      def compile
        out << "[[#{reference}]]\n"
        out << "#{'='*level} #{title}\n\n"
        if node.text_file.exists?
          out << node.text_file.content
          out << "\n\n"
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
        content.gsub( /<<([^\/]+[\/][^,]+)(,[^>])?>>/, "<<#{GitFlow::Node.to_reference $1}$2>>" )
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
        @label ||= type['label']
      end

      def title
        return @title unless @title.nil?
        @title = number ? "#{label.capitalize} #{node.node_number}. " : ""
        @title = "#{@title}#{node.attributes['title']}" if node.attributes['title']
        title
      end

      def number
        return @number unless @number.nil?
        @number = type["number"] ? node.attributes["number"] : false
      end
    end
  end
end
