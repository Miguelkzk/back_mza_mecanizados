class AddPhoneAndEmailToSuppliers < ActiveRecord::Migration[7.1]
  def change
    add_column :suppliers, :phone, :string
    add_column :suppliers, :email, :string
  end
end
