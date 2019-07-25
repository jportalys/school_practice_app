class RemoveEmailPasswordDigestToStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :students, :email, :string
    remove_column :students, :password_digest, :string
  end
end
