require "bundler/setup"
require "jets"
Jets.once  # runs once in lambda execution context

puts "testtest1"
puts "self #{self}"
puts "self.class #{self.class}"
puts "testtest2"

<% @vars.functions.each do |function_name|
  handler = @vars.handler_for(function_name)
  meth = handler.split('.').last
-%>
def <%= meth -%>(event:, context:)
  Jets.process(event, context, "<%= handler -%>")
end
<% end %>