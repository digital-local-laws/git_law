RSpec.shared_examples 'a git flow node repo' do |variable|
  include_context 'a structured git flow node'

  context "root node" do
    let(:node) do
      root_node
    end

    it 'should have a sorted_attributes method' do
      expect( GitFlow::Node.sorted_attributes( "a" ) ).
      to eql "a"
      expect( GitFlow::Node.sorted_attributes( { "b" => "a", "a" => "b" } ) ).
      to eql( { "a" => "b", "b" => "a" } )
      expect( GitFlow::Node.sorted_attributes( [ "b", "a" ] ) ).
      to eql( [ "a", "b" ] )
      expect( GitFlow::Node.sorted_attributes(
        "b" => [ "b", "a" ],
        "a" => [ "c", "d" ],
        "c" => { "b" => "a", "a" => "b" }
      ) ).to eql(
        { "a" => [ "c", "d" ],
          "b" => [ "a", "b" ],
          "c" => { "a" => "b", "b"=> "a" } }
      )
      expect( GitFlow::Node.sorted_attributes( [
        { "b" => ["b", "a"] },
        { "a" => "b" }
      ] ) ).to eql( [
        { "b" => [ "a", "b" ] },
        { "a" => "b" }
      ] )
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
    let (:node) { leaf_node }

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


    it 'should move the middle child node correctly within same level' do
      node
      toTree = middle_node.tree.gsub /part\-1/, 'part-2'
      newNode = middle_node.move toTree
      expect( middle_node.exists? ).to be false
      expect( newNode.tree ).to eql File.join middle_node.tree_parent, 'part-2.json'
      expect( File.exist? middle_node.child_container_file.absolute_path ).to be false
      expect( newNode.child_container_file.exists? ).to be true
      expect( File.exist? newNode.child_container_file.absolute_path ).to be true
      expect( node.exists? ).to be false
    end

    it "should move the node correctly within level" do
      toTree = node.tree.gsub /\-1\.json/, '-2.json'
      newNode = node.move toTree
      expect( node.exists? ).to be false
      expect( newNode.tree ).to eql File.join node.tree_parent, 'chapter-2.json'
      expect( newNode.text_file.tree ).to match /chapter-2.asc$/
      expect( File.exist? newNode.text_file.absolute_path ).to be true
    end

    it "should allow leaf to attach directly to root if middle is optional" do
      structure[0]["optional"] = true
      root_node.attributes["structure"] = structure
      root_node.save
      root = repo.working_file(root_node.tree).node
      expect( root.allowed_child_node_types.length ).to eql 2
      expect( root.allowed_child_node_types.last["label"] ).to eql "chapter"
      expect( middle_node.allowed_child_node_types.length ).to eql 1
      middle_node.attributes["type"] = "chapter"
      middle_node.save
      expect( repo.working_file(middle_node.tree).node.
        allowed_child_node_types ).to be_empty
    end
  end

  context "root node with children" do
    let(:node) { leaf_node; root_node }

    it "should compile into valid structure", focus: true do
      compiler = node.compile :node
      expect( compiler.class ).to eql GitLaw::Compilers::NodeCompiler
      compiler.compile
      f = File.open(compiler.out_path,'r')
      text = f.read
      f.close
      expect( text ).to match /^= Tompkins County Code/
    end
  end
end
