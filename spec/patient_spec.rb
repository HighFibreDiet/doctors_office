require 'spec_helper'

describe Patient do
  describe 'initialize' do
    it 'initializes a new patient with name, birthdate, doctor_id' do
      new_patient = Patient.new({'name' => 'Bob Smith','birthdate' => '1987-01-01','doctor_id' => 1})
      new_patient.should be_an_instance_of Patient
    end
     it 'knows its name and birthdate and doctor_id' do
      new_patient = Patient.new({'name' => "Sally Smith", 'birthdate' => '2014-03-18', 'doctor_id' => 1})
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
      new_patient = Patient.new({'name' => "Sally Smith", 'birthdate' => '2014-03-18', 'doctor_id' => 1})
      new_patient.save
      Patient.all.should eq [new_patient]
    end
  end

  describe '#delete' do
    it 'deletes a patient from the database' do
      new_patient = Patient.new({'name' => 'Bob DeleteTest','birthdate' => '1987-01-01','doctor_id' => 1})
      new_patient.save
      new_patient.delete
      Patient.all.should eq []
    end
  end

  describe '#update' do
    it 'updates the name and specialty_id in the database' do
      new_patient = Patient.new({'name' => 'Bob UpdateTest','birthdate' => '1987-01-01','doctor_id' => 1})
      new_patient.save
      new_patient.update("Update New Name", '2014-09-12', 9)
      results = DB.exec("SELECT * FROM patient WHERE id = #{new_patient.id};")
      results.first['name'].should eq 'Update New Name'
    end
  end

  describe '.search' do
    it 'returns a list of patients that match the search term' do
      new_patient1 = Patient.new({'name' => "Susue Q", 'birthdate' => '2002-09-30', 'doctor_id' => 2})
      new_patient2 = Patient.new({'name' => "Sam Q", 'birthdate' => '2002-09-30', 'doctor_id' => 2})
      new_patient3 = Patient.new({'name' => "Steve Q", 'birthdate' => '2002-09-30', 'doctor_id' => 2})
      new_patient1.save
      new_patient2.save
      new_patient3.save
      Patient.search("Q").should eq [new_patient1, new_patient2, new_patient3]
    end
  end
end
