class AddSortToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :position, :integer

    # Add position index to existing docs
    Document.all.each do |doc|
      doc.pages.each do |page|
        page.insert_at(0)
        page.move_to_bottom
      end
    end
  end

  def self.down
    remove_column :pages, :position
  end
end
