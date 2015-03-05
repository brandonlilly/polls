class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, unique: true, null: false
      t.timestamps
    end

    create_table :polls do |t|
      t.string :title, null: false
      t.integer :author_id, null: false
      t.timestamps
    end

    add_index :polls, :author_id

    create_table :questions do |t|
      t.text :text, null: false
      t.integer :poll_id, null: false
      t.timestamps
    end

    add_index :questions, :poll_id

    create_table :answer_choices do |t|
      t.text :text, null: false
      t.integer :question_id, null: false
      t.timestamps
    end

    add_index :answer_choices, :question_id

    create_table :responses do |t|
      t.integer :user_id, null: false
      t.integer :answer_choice_id, null: false
      t.timestamps
    end

    add_index :responses, :answer_choice_id

  end
end
