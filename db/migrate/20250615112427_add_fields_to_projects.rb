class AddFieldsToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :technologies, :string
    add_column :projects, :image, :string
  end
end
