class RemoveChallengeFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_reference :messages, :challenge, null: false, foreign_key: true
  end
end
