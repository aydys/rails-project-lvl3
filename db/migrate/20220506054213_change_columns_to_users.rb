class ChangeColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :admin, from: nil, to: false
    change_column_null :users, :email, false
    add_index :users, :email, unique: true
  end
end
