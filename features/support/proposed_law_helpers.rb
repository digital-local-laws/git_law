module ProposedLawHelpers
  def proposed_law_text_file_tree
    path = "tompkins-county-code/"
    path += @proposed_law_levels.map { |level|
      "#{level['label']}-1"
    }.join("/") + ".asc"
    path
  end
end

World( ProposedLawHelpers )
