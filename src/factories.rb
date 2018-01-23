# factories/activity.rb

FactoryBot.define do
  factory :activity do
    name       'Bitches'
    cause      { build(:cause, house: house) }
    supervisor { build(:user, house: house) }

    trait :with_parents do
      house
    end
  end
end

# activity_controller_spec.rb

RSpec.describe V1::ActivitiesController do
  let(:house) { create(:house) }
  let(:user) { create(:user, house: house, role: :admin) }

  describe '#index' do
    it 'Returns a list of activities', :dox do
      create_list(:activity, 3, house: house)
      create(:activity, :with_parents)

      get '/v1/activities', headers: authentication_headers(user)

      expect(response).to be_success
      expect(parsed_response['data'].count).to eq(3)
    end
  end
end
