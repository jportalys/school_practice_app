class CreateInvalidTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :invalid_auth_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
