class AddConfirmTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirm_token, :string
    add_index  :users, :confirm_token
  end
end
