class CreateDictatorTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :dictator_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :earned_at, null: false
      t.datetime :used_at
      t.integer :used_in_debate_id

      t.timestamps
    end
    
    add_index :dictator_tokens, [:user_id, :used_at]
    add_index :dictator_tokens, :used_in_debate_id
  end
end
