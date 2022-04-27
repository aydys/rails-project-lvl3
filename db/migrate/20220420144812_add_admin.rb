class AddAdmin < ActiveRecord::Migration[6.1]
  def change
    User.find_by(name: 'aydys')&.update(admin: true)
  end
end
