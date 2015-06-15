module GitFlow
  module LegalWorkingFile
    def self.included(base)
      base.send :before_initialize_node, :initialize_legal_node
      base.send :after_initialize_node, :initialize_metadata
      base.send :after_prepare_for_destroy, :remove_metadata
      base.send :after_update, :update_metadata
    end

    # Correctly decide whether to initialize directory or file
    def initialize_legal_node
      if structure["dir"]
        initialize_dir
      else
        initialize_file
      end
    end

    def update_metadata
      write_metadata! unless is_metadata?
    end

    def metadata=(values)
      @metadata = values
    end

    def metadata_path
      @metadata_path ||= File.join( File.dirname( absolute_path ),
        metadata_file_name )
    end

    def metadata_path_in_repo
      @metadata_path_in_repo ||= File.join( File.dirname( path_in_repo ),
        metadata_file_name )
    end

    def metadata_file_name
      @metadata_file_name ||=
        File.basename( path_in_repo, File.extname( path_in_repo ) ) + ".json"
    end

    # Is this a metadata file?
    def is_metadata?
      type == '.json'
    end

    # Retrieve metadata for the specified file in working directory
    # Metadata are stored in a separate file with the same name and a json extension
    # Project root may not have a metadata file
    # JSON file may not have a metadata file
    def metadata
      return @metadata unless @metadata.nil?
      # Root and JSON file have no metadata
      if File.basename(path_in_repo).empty? || is_metadata?
        Rails.logger.info "Metadata do not exist"
        @metadata = false
      # Otherwise, check for metadata file
      else
        Rails.logger.info "Metadata path: #{metadata_path}"
        # Load metadata file if it exists
        if File.exist? metadata_path
          Rails.logger.info "Metadata found"
          @metadata = JSON.parse File.read metadata_path
        # Otherwise, there is no metadata
        else
          Rails.logger.info "Metadata not found"
          @metadata = false
        end
      end
      # Recurse because metadata should be loaded or marked absent
      metadata
    end

    def initialize_metadata
      write_metadata!
      add_metadata!
    end

    # Gets structure applicable for a child of this node
    # Returns false if the node cannot have children
    def child_structure
      return @child_structure unless @child_structure.nil?
      Rails.logger.info "Child structure of: #{path_in_repo}"
      # If this is the root node, contained structures are codes
      @child_structure = if ancestors.first == self
        { "name" => "code",
          "number" => false,
          "dir" => true,
          "file" => false }
      # If no structure is defined
      elsif ancestors[1].metadata === false
        Rails.logger.info "My metadata are #{metadata}"
        Rails.logger.info "No structure spec for this code"
        false
      # Find the appropriate child structure from the code's structure metadata
      else
        structure = ancestors[1].metadata["structure"]
        Rails.logger.info "Structure: #{structure}"
        p = ancestors.length - 2
        Rails.logger.info "p = #{p}"
        s = structure[p]
        return @child_structure = false if s.nil?
        # Can be a directory if it is not the last node
        s["dir"] = ( s != structure.last )
        # Can be a file if it is not a directory or if its child node is
        # optional
        s["file"] = if s["dir"]
          structure[p+1]["optional"] ? true : false
        else
          true
        end
        s ? s : false
      end
    end

    def write_metadata!
      raise "Cannot write metadata for a file that is metadata." if is_metadata?
      File.open(metadata_path, 'w') do |f|
        f.write( JSON.generate( metadata, GitFlow::WorkingFile::JSON_WRITE_OPTIONS ) )
      end
    end

    def add_metadata!
      git_flow_repo.working_repo.add metadata_path
    end

    # Remove the metadata file associated with the node
    def remove_metadata
      git_flow_repo.working_repo.remove( metadata_path ) if File.exist? metadata_path
    end

    # Gets structure applicable at this working file's location
    # This describes the characteristics of this node and its peers
    def structure
      return @structure unless @structure.nil?
      @structure = if ancestors.length < 2
        false
      else
        ancestors[ ancestors.length - 2 ].child_structure
      end
    end

    # Git file status information for the metadata file associated with this
    # node
    def metadata_status_file
      repo.status.map(&:last).select { |f| f.path == metadata_path_in_repo }
    end
  end
end
