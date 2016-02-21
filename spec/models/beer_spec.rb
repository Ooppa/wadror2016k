require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved if name and style are set properly" do
    style = Style.create name:"Lager"
    beer = Beer.create name:"Ooppa's Lager", style_id:style.id
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    style = Style.create name:"Lager"
    beer = Beer.create style_id:style.id
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    puts Beer.count
    beer = Beer.create name:"Ooppa's Lager"
    puts Beer.count
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
