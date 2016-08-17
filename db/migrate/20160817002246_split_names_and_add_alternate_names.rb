class SplitNamesAndAddAlternateNames < ActiveRecord::Migration
  def self.up
      add_column :people, :last_name, :string
      
      # make best guess for splitting
      Person.all.each do |p|
          s = p.name.rindex(' ')
          if s
              p.last_name = p.name.last(p.name.length-s-1)
              p.name = p.name.first(s)
              if !p.save
                  puts "Problem migrating person: " + p.id + " (" + p.name + ")"
              end
          end
      end
      
      rename_column :people, :name, :first_name
      add_column :people, :alternate_names, :string
  end  
  
  def self.down
      remove_column :people, :alternate_names
      rename_column :people, :first_name, :name
      
      # join 'em all with a space
      Person.all.each do |p|
          p.name = p.name + ' ' + p.last_name if !p.last_name.blank?
          if !p.save
              puts "Problem rolling back person: " + p.id + " (" + p.name + ")"
          end
      end
      
      remove_column :people, :last_name
  end
end
