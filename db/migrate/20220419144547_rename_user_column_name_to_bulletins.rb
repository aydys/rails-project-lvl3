class RenameUserColumnNameToBulletins < ActiveRecord::Migration[6.1]
  def change
    rename_column :bulletins, :user_id, :author_id
  end
end
