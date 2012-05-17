Schema.define(:version => 20120514201043) do

  create_table(:events) do |t|
    t.string :name
    t.references :venue
    t.timestamps
  end

  create_table(:venues) do |t|
    t.string :name
    t.timestamps
  end

  # Idea: If we can't automagically infer from CoreData?
  # create_table(:schema_migrations) do
  #   t.integer :version, :default => false
  # end

end