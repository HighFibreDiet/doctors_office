class Doctor
  attr_reader :name, :specialty_id

  def initialize(attributes)
    @name = attributes[:name]
    @specialty_id = attributes[:specialty_id]
  end

  def save
    DB.exec("INSERT INTO doctors (name, specialty_id) VALUES ('#{@name}', #{@specialty_id});")
  end

  def self.all
    results = DB.exec("SELECT * FROM doctors;")
    doctors = []
    results.each do |result|
      name = result['name']
      specialty = result['specialty_id'].to_i
      new_doctor = Doctor.new({:name => name, :specialty_id => specialty})
      doctors << new_doctor
    end
    doctors
  end

  def ==(another_doctor)
    self.name == another_doctor.name && self.specialty_id == another_doctor.specialty_id
  end

end
