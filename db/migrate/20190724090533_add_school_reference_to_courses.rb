class AddSchoolReferenceToCourses < ActiveRecord::Migration[5.2]
  def change
    add_reference :courses, :school, index: true
  end
end
