require 'json'

# Job public methods get turned into Lambda functions.
#
# Jets::Job::Base < Jets::Lambda::Functions
# Both Jets::Job::Base and Jets::Lambda::Functions have Dsl modules included.
# So the Jets::Job::Dsl overrides some of the Jets::Lambda::Functions behavior.
class Jets::Job
  class Base < Jets::Lambda::Functions
    include Dsl

    class << self
      def process(event, context, meth)
        job = new(event, context, meth)

        puts "job/base.rb event #{event}"
        puts "job/base.rb context #{context}"
        puts "job/base.rb meth #{meth}"
        puts "job/base.rb job #{job.inspect}"

        job.send(meth)
      end

      def perform_now(meth, event={}, context={})
        new(event, context, meth).send(meth)
      end

      def perform_later(meth, event={}, context={})
        function_name = "#{self.to_s.underscore}-#{meth}"
        call = Jets::Commands::Call.new(function_name, JSON.dump(event), invocation_type: "Event")
        call.run
      end
    end
  end
end
