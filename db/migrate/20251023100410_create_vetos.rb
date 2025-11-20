class CreateVetos < ActiveRecord::Migration[8.0]
  def change
    create_table :vetos do |t|
      t.references :debate, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :vetos, [:debate_id, :option_id, :user_id], unique: true, name: 'index_vetos_on_debate_option_user'
    
  end
end
