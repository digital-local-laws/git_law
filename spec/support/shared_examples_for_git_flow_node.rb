RSpec.shared_examples 'a git flow node repo' do |variable|
  let(:repo) do
    repo = create(described_class.to_s.underscore)
    repo.working_repo
    repo
  end

  let(:structure) do
    [ { "label" => "part",
        "number" => true,
        "text" => false,
        "optional" => false },
      { "label" => "chapter",
        "number" => true,
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
      "title" => "General Provisions",
      "number" => "1"
    }
    node.save
    node
  end

  context "root node" do
    let(:node) do
      root_node
    end

    it 'should create a root node with basic parameters' do
      expect( node ).to be_a GitFlow::Node
      expect( File.exist? node.absolute_path ).to be true
      attributes = JSON.parse File.read node.absolute_path
      expect( attributes ).to be_a Hash
      expect( attributes["title"] ).to eql "Tompkins County Code"
      expect( node.parent_node.tree ).to eql ''
      expect( node.ancestor_nodes.length ).to eql 2
      expect( node.ancestor_nodes ).to include node
      expect( node.node_type["label"] ).to eql "code"
      expect( node.attributes["structure"] ).to be nil
      expect( node.child_node_structure ).to be_empty
      expect( node.allowed_child_node_types ).to be_empty
    end

    context 'with structure' do
      before(:each) do
        node.attributes["structure"] = structure
        node.save
      end

      it 'should have a child node structure' do
        expect( node.child_node_structure.first["label"] ).to eql "part"
        expect( node.allowed_child_node_types.first["label"] ).to eql "part"
      end
    end
  end

  context "middle child node" do
    let(:node) { middle_node }

    it 'should create a middle child node with basic parameters' do
      expect( node.parent_node.tree ).to eql root_node.tree
      expect( node.ancestor_nodes.length ).to eql 3
      expect( node.ancestor_nodes[1].tree ).to eql root_node.tree
      expect( node.ancestor_nodes[2].tree ).to eql node.tree
      expect( node.child_node_structure.first["label"] ).to eql "chapter"
      expect( node.node_structure.first["label"] ).to eql "part"
      expect( node.node_type["label"] ).to eql "part"
      expect( node.allowed_child_node_types.first["label"] ).to eql "chapter"
      expect( root_node.child_nodes.length ).to eql 1
      expect( root_node.child_nodes.map(&:tree)[0] ).to eql node.tree
    end
  end

  context "leaf node" do
    let (:node) do
      node = repo.working_file( File.join middle_node.tree_base,
        'chapter-1.json' ).node
      node.attributes = {
        "title" => "Administrative Provisions",
        "number" => "1"
      }
      node.save
      node
    end

    it "should create a leaf node with basic parameters" do
      expect( node.parent_node.tree ).to eql middle_node.tree
      expect( node.ancestor_nodes.length ).to eql 4
      expect( node.ancestor_nodes[1].tree ).to eql root_node.tree
      expect( node.ancestor_nodes[2].tree ).to eql middle_node.tree
      expect( node.ancestor_nodes[3].tree ).to eql node.tree
      expect( node.child_node_structure ).to be_empty
      expect( node.allowed_child_node_types ).to be_empty
      expect( node.node_structure.first["label"] ).to eql "chapter"
      expect( node.node_type["label"] ).to eql "chapter"
      expect( node.text_file.exists? ).to eql true
    end
  end
end
