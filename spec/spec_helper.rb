require 'doctor'
require 'patient'
require 'specialty'
require 'insurance'
require 'rspec'
require 'pg'

DB = PG.connect(:dbname => 'doctors_office_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctors *;")
    DB.exec("DELETE FROM patients *;")
    DB.exec("DELETE FROM specialty *;")
    DB.exec("DELETE FROM insurance_companies *;")
  end
end
