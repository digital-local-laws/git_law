class ProposedLawWorkingFile < GitFlow::WorkingFile
  include GitFlow::LegalWorkingFile
  after_initialize_file :add_to_law_metadata
  after_prepare_for_destroy :remove_from_law_metadata

  def add_to_law_metadata
    law_metadata["sections"] << {
      "tree" => path_in_repo,
      "sections" => []
    }
    write_law_metadata!
    add_law_metadata!
  end

  # Remove any section references to the node or children of the node
  # from the law metadata
  def remove_from_law_metadata
    law_metadata["sections"].reject! do |section|
      section["tree"] =~ /^#{path_in_repo}/
    end
    law_metadata["sections"].map! do |section|
      section["sections"].reject! do |subsection|
        subsection["tree"] =~ /^#{path_in_repo}/
      end
    end
    write_law_metadata!
    add_law_metadata!
  end

  def write_law_metadata!
    File.open(git_flow_repo.metadata_path, 'w') do |f|
      f.write( JSON.generate( law_metadata, JSON_WRITE_OPTIONS ) )
    end
  end

  def add_law_metadata!
    # repo.add git_flow_repo.metadata_path_in_repo
  end

  # Returns metadata about the law to which this file belongs
  def law_metadata
    return @law_metadata unless @law_metadata.nil?
    @law_metadata = JSON.parse( File.read( git_flow_repo.metadata_path ) )
  end
end
