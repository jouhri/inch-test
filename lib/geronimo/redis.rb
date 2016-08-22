module Geronimo
  module Redis
    attributes = [:manager_name, :email, :address, :mobile_phone_number, :home_phone_number]
    attributes.each do |method_name|
      define_method method_name do
        $redis.zrange("Person:#{reference}:#{method_name}", -1, -1).first
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def update_history
        @whitelist = ["manager_name", "email", "address", "mobile_phone_number", "home_phone_number"]
        @whitelist.each do | attribute |
          key = "#{self.class.to_s}:#{self.reference}:#{attribute}"
          unless $redis.zscore(key, self.attributes[attribute])
            index = $redis.zcard(key)
            $redis.zadd(key, index, self.attributes[attribute])
          end
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.send :after_save, :update_history
    end
  end
end