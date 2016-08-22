require 'rails_helper'

RSpec.describe Geronimo::Redis do
  before(:each) do
    @person_attributes = FactoryGirl.attributes_for(:person)
    @building_attributes = FactoryGirl.attributes_for(:building)
  end

  it "add new record in slq database" do
    expect{
      person = Person.create(@person_attributes)
      }.to change(Person, :count).by(1)
  end

  it "add new ordered sets Person:[reference]:address redis" do
    person = Person.create(@person_attributes)
    expect(person.address).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:address", -1, -1).first)
  end

  it "add new ordered sets Person:[reference]:email redis" do
    person = Person.create(@person_attributes)
    expect(person.email).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:email", -1, -1).first)
  end

  it "add new ordered sets Person:[reference]:mobile_phone_number redis" do
    person = Person.create(@person_attributes)
    expect(person.mobile_phone_number).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:mobile_phone_number", -1, -1).first)
  end

  it "add new ordered sets Person:[reference]:home_phone_number redis" do
    person = Person.create(@person_attributes)
    expect(person.home_phone_number).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:home_phone_number", -1, -1).first)
  end

  it "add new ordered sets Building:[reference]:manager_name redis" do
    building = Building.create(@building_attributes)
    expect(building.manager_name).to eql($redis.zrange("Building:#{@person_attributes[:reference]}:manager_name", -1, -1).first)
  end


  context "should update" do
    before(:each) do
      @person = Person.create(@person_attributes)
      @building = Building.create(@building_attributes)
    end

    it "ordered sets Person:[reference]:address redis" do
      @person.update(@person_attributes)
      expect(@person.address).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:address", -1, -1).first)
      expect(@person_attributes[:address]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:address", -1, -1).first)
    end

    it "Person address" do
      @person.update(@person_attributes)
      expect(@person.address).to eql(@person_attributes[:address])
    end


    it "ordered sets Person:[reference]:email redis" do
      @person.update(@person_attributes)
      expect(@person.email).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:email", -1, -1).first)
      expect(@person_attributes[:email]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:email", -1, -1).first)
    end

    it "Person email" do
      @person.update(@person_attributes)
      expect(@person.email).to eql(@person_attributes[:email])
    end


    it "ordered sets Person:[reference]:mobile_phone_number redis" do
      @person.update(@person_attributes)
      expect(@person.mobile_phone_number).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:mobile_phone_number", -1, -1).first)
      expect(@person_attributes[:mobile_phone_number]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:mobile_phone_number", -1, -1).first)
    end

    it "Person mobile_phone_number" do
      @person.update(@person_attributes)
      expect(@person.mobile_phone_number).to eql(@person_attributes[:mobile_phone_number])
    end

    it "ordered sets Person:[reference]:home_phone_number redis" do
      @person.update(@person_attributes)
      expect(@person.home_phone_number).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:home_phone_number", -1, -1).first)
      expect(@person_attributes[:home_phone_number]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:home_phone_number", -1, -1).first)
    end

    it "Person home_phone_number" do
      @person.update(@person_attributes)
      expect(@person.home_phone_number).to eql(@person_attributes[:home_phone_number])
    end


    it "ordered sets Building:[reference]:manager_name redis" do
      @building.update(@building_attributes)
      expect(@building.manager_name).to eql($redis.zrange("Building:#{@building_attributes[:reference]}:manager_name", -1, -1).first)
      expect(@building_attributes[:manager_name]).to eql($redis.zrange("Building:#{@building_attributes[:reference]}:manager_name", -1, -1).first)
    end

    it "Building manager_name" do
      @building.update(@building_attributes)
      expect(@building.manager_name).to eql(@building_attributes[:manager_name])
    end

  end

  context "should not update" do
    before(:each) do
      @person = Person.create(@person_attributes)
      @new_person_attributes = FactoryGirl.attributes_for(:person)
      @new_person_attributes[:reference] = @person_attributes[:reference]

      @building = Building.create(@building_attributes)
      @new_building_attributes = FactoryGirl.attributes_for(:building)
      @new_building_attributes[:reference] = @building_attributes[:reference]
    end

    it "ordered sets Person:[reference]:address redis" do
      @new_person_attributes[:address] += "900"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@new_person_attributes[:address]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:address", -1, -1).first)
      expect(@person_attributes[:address]).to_not eql($redis.zrange("Person:#{@person_attributes[:reference]}:address", -1, -1).first)
    end

    it "Person address" do
      @new_person_attributes[:address] += "900"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@person.address).to eql(@new_person_attributes[:address])
      expect(@person.address).to_not eql(@person_attributes[:address])
    end

    it "ordered sets Person:[reference]:email redis" do
      @new_person_attributes[:email] += ".com"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@new_person_attributes[:email]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:email", -1, -1).first)
      expect(@person_attributes[:email]).to_not eql($redis.zrange("Person:#{@person_attributes[:reference]}:email", -1, -1).first)
    end

    it "Person email" do
      @new_person_attributes[:email] += ".com"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@person.email).to eql(@new_person_attributes[:email])
      expect(@person.email).to_not eql(@person_attributes[:email])
    end

    it "ordered sets Person:[reference]:mobile_phone_number redis" do
      @new_person_attributes[:mobile_phone_number] += "09"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@new_person_attributes[:mobile_phone_number]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:mobile_phone_number", -1, -1).first)
      expect(@person_attributes[:mobile_phone_number]).to_not eql($redis.zrange("Person:#{@person_attributes[:reference]}:mobile_phone_number", -1, -1).first)
    end

    it "Person mobile_phone_number" do
      @new_person_attributes[:mobile_phone_number] += "09"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@person.mobile_phone_number).to eql(@new_person_attributes[:mobile_phone_number])
      expect(@person.mobile_phone_number).to_not eql(@person_attributes[:mobile_phone_number])
    end

    it "ordered sets Person:[reference]:home_phone_number redis" do
      @new_person_attributes[:home_phone_number] += "09"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@new_person_attributes[:home_phone_number]).to eql($redis.zrange("Person:#{@person_attributes[:reference]}:home_phone_number", -1, -1).first)
      expect(@person_attributes[:home_phone_number]).to_not eql($redis.zrange("Person:#{@person_attributes[:reference]}:home_phone_number", -1, -1).first)
    end

    it "Person home_phone_number" do
      @new_person_attributes[:home_phone_number] += "09"
      @person.update(@new_person_attributes)
      @person.update(@person_attributes)
      expect(@person.home_phone_number).to eql(@new_person_attributes[:home_phone_number])
      expect(@person.home_phone_number).to_not eql(@person_attributes[:home_phone_number])
    end

    it "ordered sets Building:[reference]:manager_name redis" do
      @new_building_attributes[:manager_name] += "09"
      @building.update(@new_building_attributes)
      @building.update(@building_attributes)
      expect(@new_building_attributes[:manager_name]).to eql($redis.zrange("Building:#{@person_attributes[:reference]}:manager_name", -1, -1).first)
      expect(@building_attributes[:manager_name]).to_not eql($redis.zrange("Building:#{@person_attributes[:reference]}:manager_name", -1, -1).first)
    end

    it "Building manager_name" do
      @new_building_attributes[:manager_name] += "09"
      @building.update(@new_building_attributes)
      @building.update(@building_attributes)
      expect(@building.manager_name).to eql(@new_building_attributes[:manager_name])
      expect(@building.manager_name).to_not eql(@building_attributes[:manager_name])
    end


  end

end
