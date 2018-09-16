class CreateClickStats < ActiveRecord::Migration[5.2]
  def change
    create_table :click_stats do |t|
      t.text :referer_url
      t.belongs_to :url
      t.timestamps
    end
  end
end
