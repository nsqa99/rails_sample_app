class UpdateActivationColumnNameToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :sactivation_digest, :activation_digest
  end
end
