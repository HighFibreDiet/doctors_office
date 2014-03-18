class Doctor
  attr_reader :name, :specialty_id, :id, :insurance_id

  def initialize(attributes)
    @name = attributes[:name]
    @specialty_id = attributes[:specialty_id]
    @id = attributes[:id]
    @insurance_id = attributes[:insurance_id]
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty_id, insurance_id) VALUES ('#{@name}', #{@specialty_id}, #{@insurance_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM doctors;")
    doctors = []
    results.each do |result|
      name = result['name']
      specialty = result['specialty_id'].to_i
      id = result['id'].to_i
      insurance_id = result['insurance_id']
      new_doctor = Doctor.new({:name => name, :specialty_id => specialty, :id => id, :insurance_id => insurance_id})
      doctors << new_doctor
    end
    doctors
  end

  def ==(another_doctor)
    self.id == another_doctor.id
  end

  def delete
    DB.exec("DELETE FROM doctors WHERE id = #{self.id}")
  end

  def update(name, specialty_id, insurance_id)
    @name = name
    @specialty_id = specialty_id
    @insurance_id = insurance_id
    DB.exec("UPDATE doctors SET name = '#{self.name}' WHERE id = #{self.id};")
    DB.exec("UPDATE doctors SET specialty_id = #{self.specialty_id} WHERE id = #{self.id};")
    DB.exec("UPDATE doctors SET insurance_id = #{self.insurance_id} WHERE id = #{self.id};")
  end

  def num_patients
    results = DB.exec("SELECT count(name) num_patients FROM patients WHERE doctor_id = #{self.id};")
    results.first['num_patients'].to_i
  end

  def specialty
    results = DB.exec("SELECT description FROM specialty WHERE id = #{self.specialty_id};")
    results.first['description']
  end

end
