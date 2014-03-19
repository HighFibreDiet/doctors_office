class Patient < Medicalthing
  attr_reader 'name', 'birthdate', 'doctor_id', 'id'

  def initialize(attributes)
    @name = attributes['name']
    @birthdate = attributes['birthdate']
    @doctor_id = attributes['doctor_id']
    @id = attributes['id']
  end

  def save
    results = DB.exec("INSERT INTO patient (name, birthdate, doctor_id) VALUES ('#{@name}','#{@birthdate}',#{@doctor_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM patient;")
    patients = []
    results.each do |result|
      name = result['name']
      birthdate = result['birthdate']
      doctor_id = result['doctor_id'].to_i
      id = result['id'].to_i
      patients << Patient.new({'name' => name, 'birthdate' => birthdate, 'doctor_id' => doctor_id, 'id' => id})
    end
    patients
  end

  def ==(another_patient)
    self.id == another_patient.id
  end

  def update(name, birthdate, doctor_id)
    @name = name
    @birthdate = birthdate
    @doctor_id = doctor_id
    DB.exec("UPDATE patient SET name = '#{self.name}' WHERE id = #{self.id};")
    DB.exec("UPDATE patient SET birthdate = '#{self.birthdate}' WHERE id = #{self.id};")
    DB.exec("UPDATE patient SET doctor_id = #{self.doctor_id} WHERE id = #{self.id};")
  end

  def self.search(name)
    results = DB.exec("SELECT * FROM patient WHERE name LIKE '%#{name}%';")
    patients = []
    results.each do |result|
      name = result['name']
      birthdate = result['birthdate']
      doctor_id = result['doctor_id'].to_i
      id = result['id'].to_i
      patients << Patient.new({'name' => name, 'birthdate' => birthdate, 'doctor_id' => doctor_id, 'id' => id})
    end
    patients

  end

  def doctor_name
    results = DB.exec("SELECT name FROM doctor WHERE id = #{self.doctor_id};")
    results.first['name']
  end
end
