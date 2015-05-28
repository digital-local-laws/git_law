class RemoveFilesJob < ActiveJob::Base
  queue_as :default

  def perform(path)
    FileUtils.rm_rf path
  end
end
