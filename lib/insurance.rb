class Insurance < Medicalthing
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id']
  end

  def save
    results = DB.exec("INSERT INTO insurance (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def update(name)
    @name = name
    DB.exec("UPDATE insurance SET name = '#{self.name}' WHERE id = #{self.id}")
  end

  # def self.all
  #   results = DB.exec("SELECT * FROM insurance;")
  #   insurance_companies = []
  #   results.each do |result|
  #     name = result['name']
  #     id = result['id'].to_i
  #     insurance_companies << Insurance.new(name, id)
  #   end
  #   insurance_companies
  # end

  def ==(another_insurance)
    self.name == another_insurance.name
  end
end
