class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :loan_amount
      t.float :interest_rate, :precision => 4, :scale => 2
      t.integer :term
      t.date :request_date

      t.timestamps null: false
    end
  end
end
