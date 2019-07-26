class ChangeColumnsToNotAllowNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :students, :first_name, false
    change_column_null :students, :middle_name, false
    change_column_null :students, :last_name, false
    change_column_null :students, :gender, false

    change_column_null :schools, :name, false

    change_column_null :courses, :title, false
    change_column_null :courses, :description, false

    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
  end
end
