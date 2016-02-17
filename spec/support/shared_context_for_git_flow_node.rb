RSpec.shared_context 'a structured git flow node' do
  let(:repo) do
    repo = create(described_class.to_s.underscore)
    repo.working_repo
    repo
  end

  let(:structure) do
    [ { "label" => "part",
        "number" => 'R',
        "text" => false,
        "optional" => false },
      { "label" => "chapter",
        "number" => '1',
        "text" => true,
        "optional" => false } ]
  end

  let(:root_node) do
    node = repo.working_file("tompkins-county-code.json").node
    node.attributes["title"] = "Tompkins County Code"
    node.save
    node
  end

  let(:middle_node) do
    root_node.attributes["structure"] = structure
    root_node.save
    node = repo.working_file( File.join root_node.tree_base, 'part-1.json' ).node
    node.attributes = {
      "type" => "part",
      "title" => "General Provisions",
      "number" => "1"
    }
    node.save
    node
  end

  let (:leaf_node) do
    node = repo.working_file( File.join middle_node.tree_base,
      'chapter-1.json' ).node
    node.attributes = {
      "type" => "chapter",
      "title" => "Administrative Provisions",
      "number" => "1"
    }
    node.save
    node
  end
end
