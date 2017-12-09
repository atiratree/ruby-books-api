require 'config/database'

# Sequel cheat sheet:
# http://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html
class DatabaseHelper
  class << self
    def all_books
      DB[:books].all
    end

    def get(id:)
      DB[:books].where(id: id)
    end

    def search(title:)
      DB[:books].where(Sequel.like(:title, "%#{title}%"))
    end

    def add_comment(book_id:, comment:, author:)
      DB[:comments].insert(book_id: book_id, comment: comment, author: author)
    end

    def update_comment(comment_id:, comment:, author:)
      DB[:comments].where(id: comment_id).update(comment: comment, author: author)
    end

    def delete_comment(comment_id:)
      DB[:comments].where(id: comment_id).delete
    end

    def comments(book_id:)
      DB[:comments].where(book_id: book_id)
    end

    def add_book(title:)
      DB[:books].insert(:title => title)
    end

    def delete_book(id:)
      DB[:books].where(id: id).delete
    end
  end
end

def book_mapper(item)
  { id: item[:id], title: item[:title] }
end

def comment_mapper(item)
  { id: item[:id], book_id: item[:book_id], comment: item[:comment], author: item[:author] }
end
