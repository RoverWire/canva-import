# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :rake, "cd :path && rake :task --silent :output"
set :output, { error: '/app/tmp/error.log', standard: '/app/tmp/standard.log' }

# Every 3 hours
every '0 */3 * * *' do
  rake 'token:refresh'
end

# Every minute
every '* * * * *' do
  rake 'template:download'
end

# Every minute
every '* * * * *' do
  rake '-m template:upload'
end

# Every second minute
every '*/2 * * * *' do
  rake 'template:status'
end

# Every third minute
every '*/3 * * * *' do
  rake 'folder:move'
end
