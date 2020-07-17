class CreateCreditCards < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_cards do |t|
      t.string :status
      t.integer :limit_cents
      t.timestamps
    end
  end
end
