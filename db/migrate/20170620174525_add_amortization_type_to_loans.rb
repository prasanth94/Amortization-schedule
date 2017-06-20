class AddAmortizationTypeToLoans < ActiveRecord::Migration
  def change
  	add_column :loans, :amortization_type, :string
  end
end
