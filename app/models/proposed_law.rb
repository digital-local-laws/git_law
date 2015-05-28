class ProposedLaw < ActiveRecord::Base
  belongs_to :jurisdiction, inverse_of: :proposed_laws
  belongs_to :user, inverse_of: :proposed_laws

  validates :jurisdiction, presence: true
  validates :user, presence: true
  validates :title, presence: true

  acts_as_git_flow_repo

  after_create_working_repo :initialize_working_repo

  def sections
    @sections ||= JSON.load( File.open( law_metadata_path ) )["sections"]
  end

  def metadata
    @metadata ||= JSON.load( File.open( metadata_path ) )
  end

  def write_metadata
    sections.update_metadata
    File.open( metadata_path, 'w' ) do |file|
      file << @metadata.to_json
    end
  end

  def reset_metadata
    @metadata = nil
    sections.reset
  end

  private

  class SectionCollection
    attr_accessor :proposed_law
    delegate :empty?, :first, :last, :each, :map, :length, to: :sections

    def <<( section )
      section.root = proposed_law
      sections << section
    end

    def initialize( proposed_law )
      self.proposed_law = proposed_law
      sections
    end

    def reset
      @sections = nil
    end

    def update_metadata
      self.metadata = @sections.map do |section|
        section.to_metadata
      end
    end

    private

    def sections
      @sections ||= metadata.map do |root_section|
        root_section["root"] = self
        ProposedLawSection.new( root_section ).persisted!
      end
    end

    def metadata
      proposed_law.metadata["sections"]
    end

    def metadata=(metadata)
      proposed_law.metadata["sections"] = metadata
    end
  end

  def metadata_path
    "#{working_repo_path}/laws/new/law.json"
  end

  def initialize_working_repo
    # TODO is this the best way to assure the jurisdiction has a repo initialized?
    jurisdiction.working_repo
    # Track the public-facing canonical repo, and pull up to current version
    working_repo.add_remote 'canonical', jurisdiction.repo_path
    # Master branch of proposed law will track canonical master
    working_repo.pull 'canonical', 'master'
    # TODO: Should this branch include a numerical identifier for proposed law?
    working_repo.add_remote 'proposed-law', repo_path
    working_repo.branch("proposed-law").create
    working_repo.checkout("proposed-law")
    # If proposed repo already has content, pull it in
    if working_repo.branches['proposed-law/proposed-law']
      working_repo.pull 'proposed-law', 'proposed-law'
    # Otherwise, initialize proposed repo with stub content
    else
      FileUtils.cp_r Dir.glob("#{::Rails.root}/lib/assets/proposed_law/*"), working_repo_path
      working_repo.add '.'
      working_repo.commit 'Set up initial stub for proposed law.'
      working_repo.push 'proposed-law', 'proposed-law'
    end
  end
end
