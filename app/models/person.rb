class Person < ActiveRecord::Base
  include Geronimo::Redis
end