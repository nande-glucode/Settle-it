class CreateWinStreaks < ActiveRecord::Migration[8.0]
  def change
    create_table :win_streaks do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :current_streak, null: false, default: 0
      t.integer :last_win_debate_id
      t.integer :last_decision_debate_id

      t.timestamps
    end
  end
end
