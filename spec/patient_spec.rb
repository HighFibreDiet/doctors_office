require 'spec_helper'

describe Patient do
  describe 'initialize' do
    it 'initializes a new patient with name, birthdate, doctor_id' do
      new_patient = Patient.new({:name => 'Bob Smith',:birthdate => '1987-01-01',:doctor_id => 1})
      new_patient.should be_an_instance_of Patient
    end
     it 'knows its name and birthdate and doctor_id' do
      new_patient = Patient.new({:name => "Sally Smith", :birthdate => '2014-03-18', :doctor_id => 1})
      new_patient.name.should eq "Sally Smith"
      new_patient.birthdate.should eq '2014-03-18'
      new_patient.doctor_id.should eq 1
    end
  end

  describe '.all' do
    it 'starts out empty' do
      Patient.all.should eq []
    end
  end

  describe '#save' do
    it 'lets you save a patient object to the database' do
      new_patient = Patient.new({:name => "Sally Smith", :birthdate => '2014-03-18', :doctor_id => 1})
      new_patient.save
      Patient.all.should eq [new_patient]
    end
  end
end
