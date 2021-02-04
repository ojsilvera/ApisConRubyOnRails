require 'rails_helper'
require 'byebug'

RSpec.describe 'Posts with authentication', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_post) { create(:post, user_id: user.id) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: :true) }
  let!(:other_user_post_draft) { create(:post, user_id: other_user.id, published: :false) }
  let!(:auth_headers) { { 'Authirization' => "Bearer #{user.auth_token}" } }
  let!(:other_auth_headers) { { 'Authirization' => "Bearer #{other_user.auth_token}" } }

  describe 'Should give a one post by id' do
    context 'with valid auth' do
      context 'when requitsing others authors post' do
        context 'when posts is public' do
          before { get "/posts/#{other_user_post.id}", headers: auth_headers}
          context 'payload' do
            subject { JSON.parse(response.body) }
            it { is_expected.to include(:id) }
          end
          context 'response' do
            subject { response }
            it { is_expected.to have_http_status(:ok) }
          end
        end
        context 'when posts is draft' do
          before { get "/posts/#{other_user_post_draft.id}", headers: auth_headers}
          context 'payload' do
            subject { JSON.parse(response.body) }
            it { is_expected.to include(:error) }
          end
          context 'response' do
            subject { response }
            it { is_expected.to have_http_status(:not_found) }
          end
        end
      end
      context 'when requitsing users post' do; end
    end
  end

  describe 'Should create a post' do; end

  describe 'Should update a post' do; end
end
