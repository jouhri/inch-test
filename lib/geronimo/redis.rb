module Geronimo
  module Redis
    module ClassMethods
    end

    module InstanceMethods
      @@whitelist = YAML::load(File.open("#{Rails.root}/config/whitelist.yml"))

      @@whitelist.each do |model, attributes|
        attributes.each do |method_name|
          define_method method_name do
            $redis.zrange("#{model}:#{reference}:#{method_name}", -1, -1).first
          end
        end
      end

      def update_history
        @@whitelist[self.class.to_s].each do | attribute |
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