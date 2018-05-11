require 'rails_helper'

RSpec.describe 'Visits API', type: :request do
  let!(:visits) { create_list(:visit, 10) }
  let(:visit_id) { visits.first.id }
  let(:sample_visit) { Visit.create(user_id: 2, name: "McDonald’s") }
  let(:sbx_1) { Visit.create(user_id: 2, name: "starbucks") }
  let(:sbx_2) { Visit.create(user_id: 2, name: "starbucks2") }

  describe 'GET /visits' do
    let(:valid_visit_id_attribute) { { visit_id: visits.first.id  } }
    let(:valid_multi_test_attributes) { { user_id: 2, search_string: "MCDONALD’S LAS VEGAS" } }
    let(:valid_sbx_multi_test_attributes) { { user_id: 2, search_string: "starbucks" } }
    
    before { get '/visits' }

    context 'when the request is valid' do
      before { get '/visits', params: valid_visit_id_attribute}
      it 'returns visits' do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(visits.first.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is valid' do
      before do
        sample_visit
        get '/visits', params: valid_multi_test_attributes.merge(format: :json)
      end

      it 'returns visits' do
        expect(json).not_to be_empty
        expect(json[0][0]["id"]).to eq(sample_visit.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is valid w/ specific sbx params - multiple results' do
      before do
        sbx_1
        sbx_2
        get '/visits', params: valid_sbx_multi_test_attributes.merge(format: :json)
      end

      it 'returns visits' do
        expect(json).not_to be_empty
        expect(json[0][0]["id"]).to eq(sbx_1.id)
        expect(json[0][1]["id"]).to eq(sbx_2.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /visits' do
    let(:valid_post_attributes) { { name: 'hey', user_id: '1' } }

    context 'when the request is valid' do
      before { post '/visits', params: valid_post_attributes }

      it 'creates a visit' do
        expect(json['name']).to eq('hey')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/visits', params: { name: 'noodle' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: User can't be blank/)
      end
    end
  end
end