class CreateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :options do |t|
      t.references :debate, null: false, foreign_key: true
      t.string :text, null: false
      t.integer :vote_count, null: false, default: 0
      t.boolean :vetoed, null: false, default: false
      t.integer :position, null: false

      t.timestamps
    end
    
    add_index :options, [:debate_id, :position]
  end
end
