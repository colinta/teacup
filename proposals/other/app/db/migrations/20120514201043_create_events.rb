class CreateEvents < Migration
  def change
    create_table(:events) do |t|
      t.string :name
      t.references :venue
      t.timestamps
    end
  end
end