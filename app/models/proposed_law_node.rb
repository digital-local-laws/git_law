class ProposedLawNode < GitFlow::Node
  def proposed_law
    send :git_flow_repo
  end

  # Get the node that houses the proposed law itself
  def proposed_law_node
    @proposed_law_node ||= git_flow_repo.working_file( 'proposed-law.adoc' ).node
  end
end
