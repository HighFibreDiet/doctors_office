class Patient
  attr_reader :name, :birthdate, :doctor_id

  def initialize(attributes)
    @name = attributes[:name]
    @birthdate = attributes[:birthdate]
    @doctor_id = attributes[:doctor_id]
  end

  def save
    DB.exec("INSERT INTO patients (name, birth_date, doctor_id) VALUES ('#{@name}','#{@birthdate}',#{@doctor_id});")
  end

  def self.all
    results = DB.exec("SELECT * FROM patients;")
    patients = []
    results.each do |result|
      name = result['name']
      birthdate = result['birth_date']
      doctor_id = result['doctor_id'].to_i
      patients << Patient.new({:name => name, :birthdate => birthdate, :doctor_id => doctor_id})
    end
    patients
  end

  def ==(another_patient)
    self.name == another_patient.name && self.birthdate == another_patient.birthdate && self.doctor_id == another_patient.doctor_id
  end
end
