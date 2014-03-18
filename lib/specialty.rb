class Specialty
  attr_reader :description, :id

  def initialize(description, id = nil)
    @description = description
    @id = id
  end

  def save
    results = DB.exec("INSERT INTO specialty (description) VALUES ('#{description}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM specialty;")
    specialties = []
    results.each do |result|
      description = result['description']
      id = result['id'].to_i
      specialties << Specialty.new(description, id)
    end
    specialties
  end

  def ==(another_specialty)
    self.description == another_specialty.description
  end

  def all_doctors
    results = DB.exec("SELECT * FROM doctors WHERE specialty_id = #{self.id};")
    doctors_by_specialty = []
    results.each do |result|

      name = result['name']
      specialty_id = result['specialty_id'].to_i
      doctors_by_specialty << Doctor.new({:name => name, :specialty_id => specialty_id})
    end
  doctors_by_specialty
 end
end
