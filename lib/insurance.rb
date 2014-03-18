class Insurance
  attr_reader :name, :id

  def initialize(name, id = nil)
    @name = name
    @id = id
  end

  def save
    results = DB.exec("INSERT INTO insurance_companies (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def delete
    DB.exec("DELETE FROM insurance_companies WHERE id = #{self.id}")
  end

  def update(name)
    @name = name
    DB.exec("UPDATE insurance_companies SET name = '#{self.name}' WHERE id = #{self.id}")
  end

  def self.all
    results = DB.exec("SELECT * FROM insurance_companies;")
    insurance_companies = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      insurance_companies << Insurance.new(name, id)
    end
    insurance_companies
  end

  def ==(another_insurance)
    self.name == another_insurance.name
  end
end
