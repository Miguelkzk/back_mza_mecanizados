class AddPhoneAndEmailToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :phone, :string
    add_column :clients, :email, :string
  end
end
