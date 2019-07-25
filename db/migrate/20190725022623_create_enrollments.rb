class CreateEnrollments < ActiveRecord::Migration[5.2]
  def change
    create_table :enrollments do |t|
      t.references :student, foreign_key: true, index: true
      t.references :course, foreign_key: true, index: true

      t.timestamps
    end
  end
end
