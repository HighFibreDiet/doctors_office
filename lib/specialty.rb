class Specialty < Medicalthing
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id']
  end

  def save
    results = DB.exec("INSERT INTO specialty (name) VALUES ('#{name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def update(name)
    @name = name
    DB.exec("UPDATE specialty SET name = '#{self.name}' WHERE id = #{self.id}")
  end

  # def self.all
  #   results = DB.exec("SELECT * FROM specialty;")
  #   specialties = []
  #   results.each do |result|
  #     name = result['name']
  #     id = result['id'].to_i
  #     specialties << Specialty.new(name, id)
  #   end
  #   specialties
  # end

  def ==(another_specialty)
    self.name == another_specialty.name
  end

  def all_doctors
    results = DB.exec("SELECT * FROM doctor WHERE specialty_id = #{self.id};")
    doctors_by_specialty = []
    results.each do |result|

      name = result['name']
      specialty_id = result['specialty_id'].to_i
      id = result['id'].to_i
      insurance_id = result['insurance_id'].to_i
      doctors_by_specialty << Doctor.new({'name' => name, 'specialty_id' => specialty_id, 'id' => id, 'insurance_id' => insurance_id})
    end
  doctors_by_specialty
 end
end
