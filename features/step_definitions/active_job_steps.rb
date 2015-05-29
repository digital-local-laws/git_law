Given /^all jobs have run$/ do
  Delayed::Worker.new.work_off
  Rails.logger.info "Delayed jobs: #{Delayed::Job.count}"
end
