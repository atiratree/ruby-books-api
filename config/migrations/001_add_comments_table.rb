Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      String :comment, null: false
      String :author, null: false
      Integer :book_id, null: false
    end
  end
end
