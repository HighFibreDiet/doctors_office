require 'spec_helper'


describe Insurance do
  describe 'initialize' do
    it 'initializes a insurance object with a name' do
      new_insurance = Insurance.new('Health Cross')
      new_insurance.should be_an_instance_of Insurance
    end
    it 'knows its own name' do
      new_insurance = Insurance.new('Health Cross')
      new_insurance.name.should eq 'Health Cross'
    end
  end

  describe '#save' do
    it 'sets its @id when you save it to the database' do
      new_insurance = Insurance.new('Red Shield')
      new_insurance.save
      new_insurance.id.should be_an_instance_of Fixnum
    end
    it 'saves a insurance object to the database' do
      new_insurance = Insurance.new('Red Shield')
      new_insurance.save
      Insurance.all.should eq [new_insurance]
    end
  end

  describe '.all' do
    it 'starts out empty' do
      Insurance.all.should eq []
    end
  end

end
