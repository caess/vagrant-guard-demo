When /^I execute `([^`]*)` on a running system$/ do |cmd|
  @execute_command=vagrant_execute_command

  steps %Q{ When I run `#{@execute_command} "#{cmd}"` }
end

When /^I connect to a running system interactively$/ do
  @connect_command=vagrant_interactive_command

  steps %Q{
      When I run `#{@connect_command}` interactively
  }
end

When /^I disconnect$/ do
  steps %Q{ When I type "exit $?" }
end
