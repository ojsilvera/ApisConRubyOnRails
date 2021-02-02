require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    # prueba la presencia de los campos en el modelo user
    it 'validate presence of require fields' do
      should validate_presence_of(:email)
      should validate_presence_of(:name)
      should validate_presence_of(:auth_token)
    end
    # prueba la presencia de la relacion de user con posts
    it 'validate relations' do
      should have_many(:posts)
    end
  end
end
