require 'rails_helper'

RSpec.describe 'Fern Show', type: :feature do
  describe 'Fern Show Page', :vcr do
    let(:user) { {
      'uid' => "110920554030325122207",
      'name' => "Samuel Cox",
      'email' => "samc1253@gmail.com",
      'image' => "https://lh3.googleusercontent.com/a/AGNmyxYt32X4YBRyuQij1sMMfHp6BbnKBs2Uaic2CLnLew=s96-c"
    } }

    let(:user_2) { {
        "uid"=>"113234860329276513988",
        "name"=>"Anthony Ongaro",
        "email"=>"aongaro@gmail.com",
        "image"=>
         "https://lh3.googleusercontent.com/a/AGNmyxZaV6gpWLtMVqa4RCcgDsiigEijEnmEviTX2mhQ1Q=s96-c",
        "google_id"=>"113234860329276513988"
      } }

    it 'Shows the fern information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit fern_path(1)

      within('#fern-show-header') do
        expect(page).to have_content('Erin')
        expect(page.find('img')[:src]).to eq("/assets/love-fern-1_720-2bb2636c5a7f6e6f5ed558e65f6a2d633eece82068e9813c479f104005f45b45.png")
      end
      expect(page).to have_content('Text')
      expect(page).to have_button('Water Fern')
      expect(page).to have_button('Compost Fern')
    end

    it 'Will not navigate if the user is not logged in' do
      visit fern_path(1)

      expect(page).to have_content('You must be logged in to access this page')
    end

    it 'will not navigate if the user is not the correct user for the fern' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_2)
      visit fern_path(1)

      expect(page).to have_content('Focus on your own Ferns for now!')
    end
  end

  describe 'Fern Delete', :vcr do
    let(:user) { {
      'uid' => "110920554030325122207",
      'name' => "Samuel Cox",
      'email' => "samc1253@gmail.com",
      'image' => "https://lh3.googleusercontent.com/a/AGNmyxYt32X4YBRyuQij1sMMfHp6BbnKBs2Uaic2CLnLew=s96-c"
    } }
    it 'Can Compost a fern' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_fern_path
      fill_in('name', with: 'Deletable')
      fill_in('preferred_contact_method', with: 'None')
      click_button('Plant!')
      visit fern_path(11)
      
      click_button('Compost Fern')
      expect(current_path).to eq(greenhouse_path)
      have_content('Deletable has been composted! Boundaries are healthy, good for you!')
      within("#friends") do
        expect(page).to_not have_content("Deletable")
      end
    end

    it 'displays the last 3 interactions, their positivity, and the date' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit fern_path(10)

      within "#last_3_interactions" do
        expect(page).to have_content("Last Three Interactions:")
      end

      click_button "Water Fern"
      fill_in :interaction, with: 'I watered this fern today. I love pizza. I love you.'
      click_button "Water Fern"

      within "#last_3_interactions" do
        expect(page).to have_content("You had a positive interaction on #{Date.today.strftime('%d %B %Y')}")
      end

      click_button "Water Fern"
      fill_in :interaction, with: "You Suck, I hate you"
      click_button "Water Fern"

      within "#last_3_interactions" do
        expect(page).to have_content("You had a negative interaction on #{Date.today.strftime('%d %B %Y')}")
        expect(page).to have_content("You had a positive interaction on #{Date.today.strftime('%d %B %Y')}")
      end

      click_button "Water Fern"
      fill_in :interaction, with: "You're the best"
      click_button "Water Fern"

      within "#last_3_interactions" do
        expect(page).to have_content("You had a positive interaction on #{Date.today.strftime('%d %B %Y')}")
        expect(page).to have_content("You had a negative interaction on #{Date.today.strftime('%d %B %Y')}")
        expect(page).to have_content("You had a positive interaction on #{Date.today.strftime('%d %B %Y')}")
      end
    end
  end
end