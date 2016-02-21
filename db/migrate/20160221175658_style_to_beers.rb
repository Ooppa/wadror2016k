class StyleToBeers < ActiveRecord::Migration
  def change

    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    # Muutetaan columnin nimi ensin old_style
    rename_column :beers, :style, :old_style

    # Luodaan jokaista old_stylea kohtaan uusi style-olio
    Beer.pluck(:old_style).uniq.each do |s|
      Style.create(:name => s, :description => "")
    end

    # Lisätään referenssi beer => style
    add_reference :beers, :style, foreign_key: true

    # Resetoidaan columni
    Beer.reset_column_information

    # Lisätään style jokaiseen beeriin
    Beer.all.each do |b|
      b.style_id = Style.find_by(:name => b.old_style).id
      b.save!
    end

    # Ja sama toisinpäin
    Style.all.each do |s|
      s.beers << Beer.find_by(:style_id => s.id)
    end

    # Lopuksi poistetaan vanha style
    remove_column :beers, :old_style
  end
end
