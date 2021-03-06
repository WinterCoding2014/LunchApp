require 'rails_helper'

describe SessionsController do

  context 'when not logged in' do
    describe 'POST #create' do

      it 'should create the user if it does not already exist' do
        expect(User.find_by_email('username@thoughtworks.com')).to be_nil
        post :create, shortname: 'username'
        expect(User.find_by_email('username@thoughtworks.com')).to_not be_nil
      end

      it 'should set the current_user entry' do
        roy = User.create(email: 'roy@thoughtworks.com')

        post :create, shortname: 'roy'

        expect(session[:user_id]).to_not be_nil
        expect(session[:user_id]).to eq(roy.id)
      end

    end
  end

  context 'when logged in' do
    before do
      user = User.new(email: 'logged-in@thoughtworks.com')
      user.save
      session[:user_id] = user.id
      #User.new(email: 'logged-in@thoughtworks.com')
    end

    describe 'DELETE' do
      it 'clears the current_user entry' do
        expect(session[:user_id]).to_not be_nil
        delete :destroy
        expect(session[:user_id]).to be_nil
      end
    end

  end
end