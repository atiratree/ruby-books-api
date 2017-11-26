require 'spec_helper'
require 'app'
require 'database_helper'

require 'multi_json'

describe BooksApi do
  include Rack::Test::Methods
  TEST_DATA = {
    book_title: 'jak jsem se ucil Ruby',
    comment_comment: 'comment wow',
    comment_author: 'ovcacek',
    update_comment_comment: 'comment different',
    update_comment_author: 'ovcacek' }.freeze

  def app
    BooksApi
  end

  def response
    MultiJson.load(last_response.body)
  end

  def create_test_book
    @book_id = DatabaseHelper.add_book(title: TEST_DATA[:book_title])
  end

  def delete_test_book
    DatabaseHelper.delete_book(id: @book_id)
  end

  before :each do
    create_test_book
  end

  after :each do
    delete_test_book
  end

  describe 'GET /' do
    it 'should says books size' do
      get '/'
      expect(response['message']).to match(/Our library contains \d+ books/)
    end
  end

  describe 'GET /search' do
    it 'should finds test book' do
      get "/search?title=#{TEST_DATA[:book_title]}"
      expect(response[0]['title']).to eq(TEST_DATA[:book_title])
    end
  end

  describe 'comments' do
    context 'POST /book/id/comment' do
      subject(:data) do
        {
          book_id: @book_id,
          comment: TEST_DATA[:comment_comment],
          author:  TEST_DATA[:comment_author]
        }
      end

      def create_comment
        post("/book/#{@book_id}/comment", data)
        @comment_id = response['comment_id']
      end

      def test_comments(what = '')
        expect(response.count do |comment|
          ok_comment?(comment, what)
        end).to be > 0
      end

      def ok_comment?(comment, what)
        comment['id'] == @comment_id &&
          comment['comment'] == TEST_DATA["#{what}comment_comment".to_sym] &&
          comment['author'] == TEST_DATA["#{what}comment_author".to_sym]
      end

      it 'should create comment' do
        create_comment
        expect(response['status']).to eq(app::STATUS[:success])
        expect(response['comment_id'].to_i).to be > 0
      end

      context 'GET /book/id/comments' do
        it 'should contains comment_id' do
          create_comment
          get "/book/#{@book_id}/comments"
          test_comments('')
        end
      end

      context 'PUT /book/id/comment/id' do
        subject(:update_data) do
          {
            comment: TEST_DATA[:update_comment_comment],
            author:  TEST_DATA[:update_comment_author]
          }
        end

        it 'should update comment' do
          create_comment
          create_comment
          put("/book/#{@book_id}/comment/#{@comment_id}", update_data)
          expect(response['status']).to eq(app::STATUS[:success])
          get "/book/#{@book_id}/comments"
          test_comments('update_')
        end
      end

      context 'DELETE /book/id/comment/id' do
        it 'should delete comment' do
          create_comment
          create_comment
          get("/book/#{@book_id}/comments")
          last_size = response.size
          delete("/book/#{@book_id}/comment/#{@comment_id}")
          expect(response['status']).to eq(app::STATUS[:success])
          get("/book/#{@book_id}/comments")
          expect(response.size).to be < last_size
        end
      end
    end
  end
end
