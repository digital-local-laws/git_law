class SetupGitFlowRepoJob < ActiveJob::Base
  queue_as :default

  def perform(git_flow_repo)
    git_flow_repo.with_lock do
      git_flow_repo.working_repo
    end
  end
end
