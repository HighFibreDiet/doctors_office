class Medicalthing

  def delete
    table_name = self.class.to_s.downcase
    DB.exec("DELETE FROM #{table_name} WHERE id = #{self.id}")
  end

  def self.all
    table_name = self.to_s.downcase
    results = DB.exec("SELECT * FROM #{table_name};")
    all = []
    results.each do |result|
      new_object = self.new(result)
      all << new_object
    end
    all
  end

  #STILL NEED TO UPDATE MODELS TO INITIALZE WITH HASHES (AND UPDATE SPECS)

  def self.search(name)

  end

end
