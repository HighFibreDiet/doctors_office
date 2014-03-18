class Doctor
  attr_reader :name, :specialty_id, :id

  def initialize(attributes)
    @name = attributes[:name]
    @specialty_id = attributes[:specialty_id]
    @id = attributes[:id]
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty_id) VALUES ('#{@name}', #{@specialty_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM doctors;")
    doctors = []
    results.each do |result|
      name = result['name']
      specialty = result['specialty_id'].to_i
      id = result['id'].to_i
      new_doctor = Doctor.new({:name => name, :specialty_id => specialty, :id => id})
      doctors << new_doctor
    end
    doctors
  end

  def ==(another_doctor)
    self.name == another_doctor.name && self.specialty_id == another_doctor.specialty_id && self.id == another_doctor.id
  end

  def delete
    DB.exec("DELETE FROM doctors WHERE id = #{self.id}")
  end

  def update(name, specialty_id)
    @name = name
    @specialty_id = specialty_id
    DB.exec("UPDATE doctors SET name = '#{self.name}' WHERE id = #{self.id};")
    DB.exec("UPDATE doctors SET specialty_id = #{self.specialty_id} WHERE id = #{self.id};")
  end

end
