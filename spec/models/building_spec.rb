require 'rails_helper'

RSpec.describe Building, type: :model do
  before(:each) do
    @building = FactoryGirl.create(:building)
  end

  subject{ @building }

  it {respond_to :reference}
  it {respond_to :address}
  it {respond_to :zip_code}
  it {respond_to :city}
  it {respond_to :country}
  it {respond_to :manager_name}
end
