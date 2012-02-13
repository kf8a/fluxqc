class CreateCampaignPlots < ActiveRecord::Migration
  def change
    create_table :campaign_plots do |t|
      t.integer :plot_id
      t.integer :campaign_id

      t.timestamps
    end
  end
end
