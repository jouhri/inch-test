class Person < ActiveRecord::Base
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :home_phone_number, :numericality => true, :length => { :minimum => 10, :maximum => 15 }
  validates :mobile_phone_number, :numericality => true, :length => { :minimum => 10, :maximum => 15 }
end
