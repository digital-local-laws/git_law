class ProposedLawNode < GitFlow::Node
  after_create :create_proposed_law_node_entry

  # Get the node that houses the proposed law itself
  def proposed_law_node
    @proposed_law_node ||= git_flow_repo.working_file( 'proposed-law.json' ).node
  end

  # Get the entry under the proposed law node or prepare a default one
  def proposed_law_node_entry
    return @proposed_law_node_entry unless @proposed_law_node_entry.nil?
    return @proposed_law_node_entry = false if proposed_law_node.ancestor_of_node? self
    @proposed_law_node_entry = proposed_law_node.find( "link", tree ).first ||
      proposed_law_node.new_child_node( { "link" => tree } )
  end

  # Add the proposed law node if it does not already exist
  def create_proposed_law_node_entry
    if proposed_law_node_entry && !proposed_law_node_entry.exists?
      proposed_law_node_entry.attributes["title"] = attributes["title"] if attributes["title"]
      proposed_law_node_entry.create
    end
  end
end
