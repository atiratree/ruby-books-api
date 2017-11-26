# encoding:utf-8
require 'database_helper'

require 'multi_json'
require 'sinatra'

class BooksApi < Sinatra::Base
  STATUS = {
    success: 'ok',
    fail: 'error' }.freeze
  after do
    return response unless [Hash, Array].include?(response.body.class)
    content_type('application/json', charset: 'utf-8')
    response.body = MultiJson.dump(response.body)
    response
  end

  not_found do
    status 404
    { message: "Sinatra doesn’t know this ditty" }
  end

  # welcome API page
  %w[/ /welcome].each do |route|
    get route do
      { message: "Our library contains #{DatabaseHelper.all_books.size} books" }
    end
  end

  # find books with title
  get '/search' do
    DatabaseHelper.search(title: params['title']).map do |item|
      { id: item[:id], title: item[:title] }
    end
  end

  # add new comment into database
  post '/book/:book_id/comment' do
    comment_id = DatabaseHelper.add_comment(
      book_id: params[:book_id],
      comment: params[:comment],
      author:  params[:author])
    { status: STATUS[:success], comment_id: comment_id }
  end

  # return book info
  get '/book/:id' do
    # TODO
  end

  # return comments from database
  get '/book/:book_id/comments' do
    # TODO
  end

  # update comment in database
  put '/book/:book_id/comment/:id' do
    # TODO
  end

  # delete comment from database
  delete '/book/:book_id/comment/:id' do
    # TODO
  end
end
