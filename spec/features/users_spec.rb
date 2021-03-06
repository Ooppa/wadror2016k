require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'PekkaKakkonen')
    fill_in('user_password', with:'Salasana1337')
    fill_in('user_password_confirmation', with:'Salasana1337')
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "shows users favorite style" do
    create_breweries_beers_ratings
    visit user_path(user)
    expect(page).to have_content 'Favorite style: Lager'
  end

  it "shows users favorite brewery" do
    create_breweries_beers_ratings
    visit user_path(user)
    expect(page).to have_content 'Favorite'
  end

  def create_breweries_beers_ratings
    FactoryGirl.create :brewery, name:"Koff"
    FactoryGirl.create :brewery, name:"Olvi"
    FactoryGirl.create :style, name:"Lager", description:"Lager is beer."
    FactoryGirl.create :beer, style_id:1, brewery_id:1
    FactoryGirl.create :beer, style_id:1, brewery_id:2
    FactoryGirl.create :rating2, beer_id:1, user_id:1
    FactoryGirl.create :rating2, beer_id:1, user_id:1
    FactoryGirl.create :rating, beer_id:2, user_id:1
    FactoryGirl.create :rating, beer_id:2, user_id:1
  end
end
