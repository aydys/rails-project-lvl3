class AddAdminMentor < ActiveRecord::Migration[6.1]
  def change
    User.find_by(name: 'Vasilisa')&.update(admin: true)
  end
end
