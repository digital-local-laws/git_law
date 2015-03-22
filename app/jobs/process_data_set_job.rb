class ProcessDataSetJob < ActiveJob::Base
  queue_as :default

  def perform(data_set_id)
    DataSet.transaction do
      DataSet.lock.find(data_set_id).process!
    end
  end
end
