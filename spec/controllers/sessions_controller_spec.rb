require 'rails_helper'

describe SessionsController do

  context 'when not logged in' do
    describe 'POST #create' do

      it 'should create the user if it does not already exist' do
        expect(User.find_by_email('username@thoughtworks.com')).to be_nil
        post :create, shortname: 'username'
        expect(User.find_by_email('username@thoughtworks.com')).to_not be_nil
      end

      it 'should set the session[:user] entry' do
        roy = User.create(email: 'roy@thoughtworks.com')

        post :create, shortname: 'roy'

        expect(request.session[:user]).to_not be_nil
        expect(request.session[:user]).to eq(roy)
      end

    end
  end

  context 'when logged in' do
    before do
      request.session[:user] = User.new(email: 'logged-in@thoughtworks.com')
    end

    describe 'DELETE' do
      it 'clears the session[:user] entry' do
        expect(request.session[:user]).to_not be_nil
        delete :destroy
        expect(request.session[:user]).to be_nil
      end
    end

  end
end