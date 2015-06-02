RSpec.shared_examples "a git flow repo" do
  let(:repo) { create( described_class.to_s.underscore.to_sym ) }
  context "initialize repo" do
    before(:each) { repo }
    it "should initialize a canonical repo with repo()" do
      expect( repo.repo? ).to be false
      repo.repo
      expect( repo.repo? ).to be true
    end
    it "should create a canonical working directory with working_repo()" do
      expect( repo.working_repo? ).to be false
      repo.working_repo
      expect( repo.working_repo? ).to be true
    end
    it "should create canonical repo and working directory on queue run" do
      expect( repo.repo? ).to be false
      expect( repo.working_repo? ).to be false
      Delayed::Worker.new.work_off
      expect( repo.repo? ).to be true
      expect( repo.working_repo? ).to be true
    end
    it "should destroy canonical repo and working directory on queue run after destroy" do
      repo.working_repo
      repo_path = repo.repo_path
      working_repo_path = repo.working_repo_path
      expect(File.exist? repo_path ).to be true
      expect(File.exist? working_repo_path ).to be true
      repo.destroy
      Delayed::Worker.new.work_off
      expect(File.exist? repo_path ).to be false
      expect(File.exist? working_repo_path ).to be false
    end
  end
  context "working_file" do
    it "should handle repo root" do
      file = repo.working_file( "" )
      expect( file.exists? ).to be false
      repo.working_repo
      expect( file.file_name ).to eq ""
      expect( file.exists? ).to be true
      expect( file.type ).to eq 'dir'
      expect( file.content.class ).to be Array
      file.content.each do |entry|
        expect( entry.class ).to be repo.class.const_get(:WORKING_FILE_CLASS)
      end
      expect( file.metadata ).to be false
      expect( file.ancestors.length ).to eq 1
    end
    it "should handle repo subdir with metadata" do
      repo.working_repo
      file = repo.working_file( "laws" )
      expect( file.type ).to eq 'dir'
      expect( file.metadata.class ).to be Hash
      expect( file.ancestors.length ).to eq 2
    end
  end
end
