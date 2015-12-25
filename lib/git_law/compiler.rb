module GitLaw
  class Compiler
    attr_accessor :node, :out
    def initialize( node )
      unless node.is_a? ::GitFlow::Node
        raise ArgumentError, "node must be a GitFlow::Node"
      end
      self.node = node
    end

    # Output file into which compilation for this node is dumped
    def out
      return @out if @out
      FileUtils.mkdir_p out_base unless File.exist? out_base
      @out = File.open( "#{out_path}", 'w' )
    end

    # Specific output of compilation is implemented in subclasses
    def compile
      raise NotImplementedError
    end

    # Directory in which output file will be placed
    def out_base
      return @out_base if @out_base
      @out_base = File.join ::Rails.root, 'tmp', ::Rails.env, 'compile'
      @out_base = File.join @out_base, node.tree_parent unless node.tree_parent.empty?
      out_base
    end

    # File in which output will be placed
    def out_path
      @out_path ||= File.join out_base, node.text_file.file_name
    end

    # Close compilation of this node
    def close
      out.close
    end
  end
end
