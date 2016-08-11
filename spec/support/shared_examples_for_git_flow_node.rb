RSpec.shared_examples 'a git flow node repo' do
  include_context 'a structured git flow node'

  context "root node" do
    let(:node) do
      root_node
    end

    it "should appear among the project root's children" do
      node
      expect( repo.working_file('').node.child_nodes ).to include( node )
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
      attributes, text = YAML::FrontMatter.extract File.read node.absolute_path
      expect( attributes ).to be_a Hash
      expect( attributes["title"] ).to eql "Tompkins County Code"
      expect( node.parent_node.tree ).to eql ''
      expect( node.ancestor_nodes.length ).to eql 2
      expect( node.ancestor_nodes ).to include node
      expect( node.node_type["label"] ).to eql "code"
      expect( node.attributes["structure"] ).to be nil
      expect( node.child_node_structure ).to be_empty
      expect( node.allowed_child_node_types ).to be_empty
      expect( node.to_reference ).to eql 'tompkins-county-code'
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
      expect( node.to_reference ).to eql 'tompkins-county-code_part-1'
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
    end

    it "should permit leaf node text to be set through attributes", focus: true do
      node.attributes = { 'text' => "Some text for child node." }
      expect( node.save ).to be true
      expect( repo.working_file(node.tree).node.text ).to eql "Some text for child node."
    end

    it 'should move the middle child node correctly within same level' do
      node
      toTree = middle_node.tree.gsub /part\-1/, 'part-2'
      newNode = middle_node.move toTree
      expect( middle_node.exists? ).to be false
      expect( newNode.tree ).to eql File.join middle_node.tree_parent, 'part-2.adoc'
      expect( File.exist? middle_node.child_container_file.absolute_path ).to be false
      expect( newNode.child_container_file.exists? ).to be true
      expect( File.exist? newNode.child_container_file.absolute_path ).to be true
      expect( node.exists? ).to be false
    end

    it "should move the node correctly within level" do
      toTree = node.tree.gsub /\-1\.adoc/, '-2.adoc'
      newNode = node.move toTree
      expect( node.exists? ).to be false
      expect( newNode.tree ).to eql File.join node.tree_parent, 'chapter-2.adoc'
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

  context "root node with children", focus: true do
    def compiled_text(node)
      f = File.open node.compile(:node).out_path
      text = f.read
      f.close
      text
    end

    let(:node) { leaf_node; root_node }

    it "should compile into valid structure" do
      compiler = node.compile :node
      expect( compiler.class ).to eql GitLaw::Compilers::NodeCompiler
      compiler.compile
      text = compiled_text node
      expect( text ).to match /^= Tompkins County Code/
      expect( text ).to include ":doctype: book\n"
      expect( text ).to include ":!sectnums:\n"
      expect( text ).to include "\n\n// tag::tompkins-county-code_content[]"
      expect( text ).to include "\n\ninclude::tompkins-county-code/part-1.adoc[]"
      expect( text ).to include "\n\n// end::tompkins-county-code_content[]"
      text = compiled_text middle_node
      expect( text ).to match /^== Part I. General Provisions/
      expect( text ).not_to include ":doctype: book\n"
      expect( text ).not_to include ":!sectnums:\n"
      expect( text ).to include "\n\ninclude::part-1/chapter-1.adoc[]"
      text = compiled_text leaf_node
      expect( text ).to match /^=== Chapter 1. Administrative Provisions/
    end

    it "should correctly number lower roman sections" do
      structure[0]["number"] = 'r'
      node.compile(:node).compile
      text = compiled_text middle_node
      expect( text ).to match /^== Part i. General Provisions/
    end

    it "should correctly number lower alpha sections" do
      structure[0]["number"] = 'a'
      node.compile(:node).compile
      text = compiled_text middle_node
      expect( text ).to match /^== Part a. General Provisions/
    end

    it "should correctly number lower alpha sections" do
      structure[0]["number"] = 'A'
      node.compile(:node).compile
      text = compiled_text middle_node
      expect( text ).to match /^== Part A. General Provisions/
    end

    context "containing references" do
      let(:ref_node) do
        ref_node = repo.working_file( File.join middle_node.tree_base,
          'chapter-2.adoc' ).node
        ref_node.attributes = {
          "title" => "Reference to Administrative Provisions",
          "number" => "2"
        }
        ref_node.text = "See <<#{ref_node_text}>>"
        ref_node.save
        ref_node
      end

      let(:ref_node_text) { "part-1/chapter-1" }

      let(:text) { compiled_text ref_node }

      before(:each) do
        ref_node
        node.compile(:node).compile
        text = compiled_text ref_node
      end

      it "should interpolate references correctly" do
        expect( text ).to( include(
          "<<tompkins-county-code_part-1_chapter-1," +
          "Chapter 1. Administrative Provisions>> " +
          "of Tompkins County Code, Part I"
        ) )
      end

      context "should omit description when overridden" do
        let(:ref_node_text) { "part-1/chapter-1,Chapter 1" }

        it "should interpolate references correctly" do
          expect( text ).to( include(
            "<<tompkins-county-code_part-1_chapter-1," +
            "Chapter 1>>"
          ) )
        end
      end
    end
  end
end
