require 'spec_helper'

describe 'Integration testing' do
  context 'post 1' do
    it 'returns status 200' do
      get 'https://jsonplaceholder.typicode.com/posts/1', {'login' => 'WAT'}
      expect_status (200)
    end
  end

  context 'post 2' do
    it 'returns status 200' do
      get 'httpsjsonplaceholder.typicode.com/posts/2', {'login' => 'WAT'}
      expect_status (201)
    end
  end

  context 'post 3' do
    it 'returns status 200' do
      skip
    end
  end
end
