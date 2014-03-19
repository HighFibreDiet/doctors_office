require 'spec_helper'

describe Specialty do
  describe 'initialize' do
    it 'initializes a Specialty object with a name' do
      new_specialty = Specialty.new({'name' => 'Neurosurgery'})
      new_specialty.should be_an_instance_of Specialty
    end
    it 'knows its own name' do
      new_specialty = Specialty.new({'name' => 'Neurosurgery'})
      new_specialty.name.should eq 'Neurosurgery'
    end

  end

  describe '#save' do
    it 'sets its @id when you save it to the database' do
      new_specialty = Specialty.new({'name' => 'OBGYN'})
      new_specialty.save
      new_specialty.id.should be_an_instance_of Fixnum
    end
    it 'saves a specialty object to the database' do
      new_specialty = Specialty.new({'name' => 'OBGYN'})
      new_specialty.save
      Specialty.all.should eq [new_specialty]
    end
  end

  describe '#delete' do
    it 'deletes a specialty and from the database' do
      new_specialty = Specialty.new({'name' => 'OBGYN'})
      new_specialty.save
      new_specialty.delete
      Specialty.all.should eq []
    end
  end

  describe '#update' do
    it 'updates the name in the database' do
      new_specialty = Specialty.new({'name' => 'OBGYN'})
      new_specialty.save
      new_specialty.update('OB-GYN')
      results = DB.exec("SELECT * FROM specialty WHERE id = #{new_specialty.id};")
      results.first['name'].should eq 'OB-GYN'
    end
  end

  describe '.all' do
    it 'starts out empty' do
      Specialty.all.should eq []
    end
  end

  describe 'all_doctors' do
    it 'is able to list all of the doctors for a specialty instance' do
      new_specialty = Specialty.new({'name' => 'OBGYN'})
      new_specialty.save
      new_doctor1 = Doctor.new({'name' => "Susie Smith", 'specialty_id' => new_specialty.id, 'insurance_id' => 7})
      new_doctor1.save
      new_doctor2 = Doctor.new({'name' => "Bob Smith", 'specialty_id' => new_specialty.id, 'insurance_id' => 7})
      new_doctor2.save
      new_specialty.all_doctors.should eq [new_doctor1, new_doctor2]
    end
  end
end
