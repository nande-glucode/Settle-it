class CreateDebates < ActiveRecord::Migration[8.0]
  def change
    create_table :debates do |t|
      t.string :title, null: false
      t.integer :mode, null: false, default: 0
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :group, null: true, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :voting_ends_at
      t.integer :winner_option_id, null: true
      t.references :parent_debate, null: true, foreign_key: { to_table: :debates }
      t.boolean :creator_votes, null: false, default: true

      t.timestamps
    end
    
   
    add_index :debates, :status
    add_index :debates, [:group_id, :status]
    add_index :debates, :winner_option_id
  end 
end