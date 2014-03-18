require './lib/doctor'
require './lib/patient'
require './lib/specialty'
require './lib/insurance'
require 'rspec'
require 'pg'

DB = PG.connect(:dbname => 'doctors_office')

@current_patient
@current_doctor
@current_insurance
@current_specialty

def main_menu
  puts "****** Welcome to the Doctor's Office ******* "
  puts "\nPlease choose a selection from the menu below:"
  puts "ADD Options:"
  puts "1.  Add a doctor."
  puts "2.  Add a patient."
  puts "3.  Add a new specialty."
  puts "4.  Add a new insurance company."
  puts "VIEW Options:"
  puts "5.  View all doctors."
  puts "6.  View all patients."
  puts "7.  Search for a patient by name"
  puts "8.  View insurance companies."
  puts "9.  View all specialties."
  puts "\n Press x to exit.\n"

  user_choice = gets.chomp
  case user_choice
  when '1'
    add_doctor
    main_menu
  when '2'
    add_patient
  when '3'
    add_specialty
  when '4'
    add_insurance
  when '5'
    view_doctors
    doctors_menu
  when '6'
    view_patients
  when '7'
    search_patients
    patients_menu
  when '8'
    view_insurances
    insurances_menu
  when '9'
    view_specialties
    specialties_menu
  when 'x'
    puts "Good-bye!"
  else
    puts "Invalid selection.  Please try again."
    main_menu
  end
end

# def add_new(thing)
#   thing =
#   # puts "Please enter the name of the new #{thing.class.to_s.downcase}"
#   puts "Please enter the name of the new #{thing}"
#   save_name = gets.chomp
#   medicalthing = Object.const_get(thing)
# end

def add_doctor
  puts "\nPlease enter the name of your new doctor:"
  doctor_name = gets.chomp
  puts "\n"
  view_specialties
  puts "\nPlease enter the doctor's specialty (by id)"
  doctor_specialty_index = gets.chomp.to_i
  puts "\n"
  view_insurances
  puts "\nPlease enter the doctor's preferred insurance company (by id)"
  doctor_insurance_index = gets.chomp.to_i

  doctor_specialty_id = Specialty.all[doctor_specialty_index - 1].id
  doctor_insurance_id = Insurance.all[doctor_insurance_index - 1].id

  new_doctor = Doctor.new({:name => doctor_name, :specialty_id => doctor_specialty_id, :insurance_id => doctor_insurance_id})
  new_doctor.save
  puts "\n#{doctor_name} was successfully added!\n"
end

def add_patient
  puts "\nPlease enter the name of your new patient:"
  patient_name = gets.chomp
  puts "\n"
  view_doctors
  puts "\nPlease enter the patient's doctor (by id)"
  patient_doctor_index = gets.chomp.to_i
  puts "\nPlease enter the patient's date of birth (yyyy-mm-dd)"
  patient_birthdate = gets.chomp

  patient_doctor_id = Doctor.all[patient_doctor_index - 1].id

  new_patient = Patient.new({:name => patient_name, :doctor_id => patient_doctor_id, :birthdate => patient_birthdate})
  new_patient.save
  puts "\n#{patient_name} was successfully added!\n"
end

def add_specialty
  puts "\nPlease enter a new specialty:"
  specialty_name = gets.chomp
  puts "\n"
  new_specialty = Specialty.new(specialty_name)
  new_specialty.save
  puts "#{specialty_name} saved!"
end

def add_insurance
  puts "\nPlease enter a new insurance:"
  insurance_name = gets.chomp
  puts "\n"
  new_insurance = Insurance.new(insurance_name)
  new_insurance.save
  puts "#{insurance_name} saved!"
end

def view_specialties
  Specialty.all.each_with_index do |specialty, index|
    puts "#{index+1}. #{specialty.description}"
  end
end

def view_insurances
  Insurance.all.each_with_index do |insurance, index|
    puts "#{index+1}. #{insurance.name}"
  end
end

def view_doctors
  Doctor.all.each_with_index do |doctor, index|
    puts "#{index+1}. #{doctor.name}, #{doctor.specialty}"
  end
end

def view_patients
  Patient.all.each_with_index do |patient, index|
    puts "#{index+1}. #{patient.name}, #{patient.birthdate}, Dr.#{patient.doctor_name}"
  end
  puts "Press 'm' for the Main Menu or the number of the patient to update."
  user_choice = gets.chomp
  if user_choice == 'm'
    main_menu
  else
    @current_patient = Patient.all[user_choice.to_i-1]
    patients_menu
  end
end

def patients_menu
  puts "Options for patient '#{@current_patient.name}':"
  puts "Press 'd' to delete this patient"
  puts "Press 'u' to update this patient's information"
  puts "Press 'm' to return to the main menu"

  user_choice = gets.chomp

  case user_choice
  when 'd'
    @current_patient.delete
  when 'u'
    puts "Enter the updated patient name"
    new_name = gets.chomp
    puts "Enter the updated patient birthdate"
    new_birthdate = gets.chomp
    puts "\n"
    view_doctors
    puts "Enter the updated patient doctor id"
    new_doctor_index = gets.chomp.to_i

    new_doctor_id = Doctor.all[new_doctor_index - 1].id

    @current_patient.update(new_name, new_birthdate, new_doctor_id)

    puts "The record for #{@current_patient.name} has been updated!"
  when 'm'
    main_menu
  else
    puts "That was not valid input. Please try again."
    patients_menu
  end
  main_menu
end

def doctors_menu
  puts "Enter the number of a doctor to update/delete, or see patient count"
  puts "Press 'm' to return to the main menu"

  user_choice = gets.chomp

  case user_choice
  when 'm'
    main_menu
  else
    @current_doctor = Doctor.all[user_choice.to_i - 1]
    doctor_update
  end
end

def doctor_update
  puts "Options for #{@current_doctor.name}:"
  puts "Press 'd' to delete this doctor"
  puts "Press 'u' to update this doctor's information"
  doctor_choice = gets.chomp
  case doctor_choice
  when 'd'
    @current_doctor.delete
  when 'u'
    puts "Enter the updated doctor name"
    new_name = gets.chomp
    puts "\n"
    view_specialties
    puts "Enter the updated doctor specialty_id"
    new_specialty_index = gets.chomp.to_i
    puts "\n"
    view_insurances
    puts "Enter the updated doctor insurance_id"
    new_insurance_index = gets.chomp.to_i

    new_specialty_id = Specialty.all[new_specialty_index - 1].id
    new_insurance_id = Insurance.all[new_insurance_index - 1].id

    @current_doctor.update(new_name, new_specialty_id, new_insurance_id)

    puts "The record for #{@current_doctor.name} has been updated!"
  end
  view_doctors
  doctor_menu
end

def specialties_menu

end

def insurance_menu

end

def view_doctors_by_specialty

end

def search_patients
  puts "Please enter a patient name to search:"
  patient_name = gets.chomp
  results = Patient.search(patient_name)
  results.each_with_index do |result, index|
    puts "#{index+1}. #{result.name} - #{result.birthdate} - #{result.doctor_name}"
  end

  puts "\nPress 'm' for the Main Menu or the number of the patient to update."
  user_choice = gets.chomp
  if user_choice == 'm'
    main_menu
  else
    @current_patient = results[user_choice.to_i-1]
    patients_menu
  end
end

main_menu
