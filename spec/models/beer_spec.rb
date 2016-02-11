require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved if name and style are set properly" do
    beer = Beer.create name:"Ooppa's Lager", style:"Lager"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    beer = Beer.create style:"Lager"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"Ooppa's Lager"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
