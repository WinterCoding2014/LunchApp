class AddMenuLinkToVenues < ActiveRecord::Migration
  def change
    self.up
    add_column :venues, :menu_link, :text
  end
end
