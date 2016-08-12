module ProposedLawHelpers
  def proposed_law_node_tree
    path = "tompkins-county-code/"
    path += @proposed_law_levels.map { |level|
      "#{level['label']}-1"
    }.join("/") + ".adoc"
    path
  end
end

World( ProposedLawHelpers )
