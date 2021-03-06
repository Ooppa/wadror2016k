require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:style) { FactoryGirl.create :style, name:"Lager", description:"Lager is beer."}
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")

    FactoryGirl.create(:style, name: "Lager", description: "Lager is beer.")
    FactoryGirl.create(:style, name: "IPA", description: "IPA is beer as well.")
  end

  it "when creating new beer with valid name, it is added to database" do
    visit new_beer_path
    #save_and_open_page
    fill_in('beer[name]', with:'Pikku Kakkonen')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "when creating new beer with invalid name, it is not added to database" do
    visit new_beer_path
    fill_in('beer[name]', with:'')
    click_button "Create Beer"
    expect(page).to have_content 'Name can\'t be blank'
    expect(Beer.count).to eq(0)
  end
end
