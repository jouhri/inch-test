require 'rails_helper'

RSpec.describe Person, type: :model do
  before(:each) do
    @person = FactoryGirl.create(:person)
  end

  subject { @person }

  it { respond_to :reference }

  it { respond_to :email}
  # it { should_not allow_value("test@test").for(:email) }
  # it { should_not allow_value("testtest").for(:email) }
  # it { should allow_value("test@test.com").for(:email) }

  it { respond_to :home_phone_number}
  # it { should allow_value("0129345768").for(:home_phone_number)}
  # it { should_not allow_value("0040444").for(:home_phone_number)}
  # it { should_not allow_value("0odieke").for(:home_phone_number)}

  it { respond_to :mobile_phone_number}
  # it { should allow_value("0129345768").for(:mobile_phone_number)}
  # it { should_not allow_value("0040444").for(:mobile_phone_number)}
  # it { should_not allow_value("0odieke").for(:mobile_phone_number)}

  it { respond_to :firstanme}
  it { respond_to :last_name}
  it { respond_to :address}
end
