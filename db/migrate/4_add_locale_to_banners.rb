class AddLocaleToBanners < ActiveRecord::Migration
  def change
    add_column :refinery_banners, :locale, :string
  end
end