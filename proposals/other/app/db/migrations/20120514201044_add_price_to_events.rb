class AddPriceToEvents < Migration
  def change
    add_column :events, :price, :float, :default => 0.00
  end
end