require 'spec_helper'

describe Doctor do
  describe 'initialize' do
    it 'initializes a new Doctor object' do
      new_doctor = Doctor.new({'name' => "Dr. John Smith", 'specialty_id '=> 2})
      new_doctor.should be_an_instance_of Doctor
    end
    it 'knows its name and specialty' do
      new_doctor = Doctor.new({'name' => "Sally Smith", 'specialty_id '=> 1, 'insurance_id' => 5})
      new_doctor.name.should eq "Sally Smith"
      new_doctor.specialty_id.should eq 1
      new_doctor.insurance_id.should eq 5
    end
  end

  describe '.all' do
    it 'starts off empty' do
      Doctor.all.should eq []
    end
  end

  describe '#save' do
    it 'allows a doctor object to save itself to the database' do
      new_doctor = Doctor.new({'name' => "Sally Smith", 'specialty_id '=> 1, 'insurance_id' => 7})
      new_doctor.save
      Doctor.all.should eq [new_doctor]
    end
  end

  describe '#==' do
    it 'considers doctor objects with the same name and specialty_id to be equal' do
      new_doctor1 = Doctor.new({'name' => "Sally Smith", 'specialty_id '=> 1, 'insurance_id' => 7})
      new_doctor2 = Doctor.new({'name' => "Sally Smith", 'specialty_id '=> 1, 'insurance_id' => 7})
      new_doctor1.should eq new_doctor2
    end
  end

  describe '#delete' do
    it 'deletes a doctor from the database' do
      new_doctor = Doctor.new({'name' => "Doctor Name", 'specialty_id '=> 9, 'insurance_id' => 7})
      new_doctor.save
      new_doctor.delete
      Doctor.all.should eq []
    end
  end

  describe '#update' do
    it 'updates the name and specialty_id and insurance_id in the database' do
      new_doctor = Doctor.new({'name' => "Doctor Name", 'specialty_id '=> 9, 'insurance_id' => 7})
      new_doctor.save
      new_doctor.update("Doctor New Name", 9, 8)
      results = DB.exec("SELECT * FROM doctor WHERE id = #{new_doctor.id};")
      results.first['name'].should eq 'Doctor New Name'
    end
  end

  describe '#num_patients' do
    it 'returns a count of the number of patients for a specific doctor' do
      new_doctor = Doctor.new({'name' => "Doctor Name", 'specialty_id '=> 9, 'insurance_id' => 7})
      new_doctor.save
      new_patient1 = Patient.new({'name' => "Susue Q", 'birthdate' => '2002-09-30', 'doctor_id' => new_doctor.id})
      new_patient2 = Patient.new({'name' => "Sam Q", 'birthdate' => '2002-09-30', 'doctor_id' => new_doctor.id})
      new_patient3 = Patient.new({'name' => "Steve Q", 'birthdate' => '2002-09-30', 'doctor_id' => new_doctor.id})
      new_patient1.save
      new_patient2.save
      new_patient3.save
      new_doctor.num_patients.should eq 3
    end
  end

end
