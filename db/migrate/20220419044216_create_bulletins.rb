class CreateBulletins < ActiveRecord::Migration[6.1]
  def change
    create_table :bulletins do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true, index: true
      t.references :category, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
