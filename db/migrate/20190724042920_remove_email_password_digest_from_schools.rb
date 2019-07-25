class RemoveEmailPasswordDigestFromSchools < ActiveRecord::Migration[5.2]
  def change
    remove_column :schools, :email, :string
    remove_column :schools, :password_digest, :string
  end
end