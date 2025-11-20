class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.references :debate, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    
    # Composite unique index - one vote per user per debate
    add_index :votes, [:debate_id, :user_id], unique: true
    
  end
end
