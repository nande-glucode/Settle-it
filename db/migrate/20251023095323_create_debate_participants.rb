class CreateDebateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :debate_participants do |t|
      t.references :debate, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :acknowledged, null: false, default: false
      t.datetime :invited_at, null: false

      t.timestamps
    end
    
    add_index :debate_participants, [:debate_id, :user_id], unique: true
  end
end
