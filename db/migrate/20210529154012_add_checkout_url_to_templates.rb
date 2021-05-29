class AddCheckoutUrlToTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :templates, :checkout_url, :string
  end
end
