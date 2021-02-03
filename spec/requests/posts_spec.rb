require 'rails_helper'
require 'byebug'

RSpec.describe 'Posts', type: :request do
  describe 'GET /post' do
    it 'should return OK' do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end

    describe '-> Should search' do
      let!(:hola_mundo) { create(:published_post, title: 'hola mundo') }
      let!(:hola_rails) { create(:published_post, title: 'hola rails') }
      let!(:curso_rails) { create(:published_post, title: 'curso rails') }
      it '-> should filtering post by title' do
        get "/posts?search=hola"
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(2)
        expect(payload.map { |p| p['id'] }.sort).to eq([hola_mundo.id, hola_rails.id].sort)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '-> with data in the DB' do
    let!(:posts) { create_list(:post, 10, published: true) }
    before {get '/posts'}
    it 'return all posts' do
      # byebug
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end

  describe '-> GET /posts/{id}' do
    let(:post) { create(:post) }

    it 'return a post' do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq(post.published)
      expect(payload['author']['name']).to eq(post.user.name)
      expect(payload['author']['email']).to eq(post.user.email)
      expect(payload['author']['id']).to eq(post.user.id)
      expect(response).to have_http_status(200)
    end
  end

  describe '-> POST /posts' do
    let!(:user) { create(:user) }

    it '-> should create a post' do
      req_payload = {
        post: {
          title: 'title',
          content: 'contend',
          published: false,
          user_id: user.id
        }
      }

      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to_not be_nil
      expect(response).to have_http_status(:created)
    end

    it '-> should return error message on invalid post' do
      req_payload = {
        post: {
          title: 'title',
          contend: 'contend',
          publised: false,
          user: user.id

        }
      }

      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '-> PUT /posts/{id}' do
    let!(:article) { create(:post) }

    it '-> should create a post' do
      req_payload = {
        post: {
          title: 'title',
          content: 'contend',
          published: true
        }
      }

      # POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(article.id)
      expect(response).to have_http_status(:ok)
    end


    it '-> should return error message on invalid post' do
      req_payload = {
        post: {
          title: nil,
          contend: nil,
          publised: false
        }
      }

      # POST HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

end
