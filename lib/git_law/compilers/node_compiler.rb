module GitLaw
  module Compilers
    class NodeCompiler
      attr_accessor :node
      def initialize( node )
        self.node = node
      end
      def compile
        out << "[[#{reference}]]\n"
        out << "#{'='*level} #{title}\n\n"
        if node.content_file.exists?
          out << node.content_file.content
          out << "\n\n"
        end
      end
      def content
        @content ||= if node.content_file.exists?
          parse_content( node.content_file.content )
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
      def structure
        @structure ||= node.structure
      end
      def level
        @level ||= node.tree.split("/")
      end
      def title
        return @title unless @title.nil?
        @title = number ? "#{label.capitalize} #{node.attributes['number']}. " : ""
        @title = "#{@title}#{node.attributes['title']}" if node.attributes['title']
        title
      end
      def number
        return @number unless @number.nil?
        @number = structure["number"] ? node.attributes["number"] : false
      end
      def compile
      end
    end
  end
end
