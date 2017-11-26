require 'config/database'

# Sequel cheat sheet:
# http://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html
class DatabaseHelper
  class << self
    def all_books
      DB[:books].all
    end

    def get(id:)
      # TODO
    end

    def search(title:)
      DB[:books].where(Sequel.like(:title, "%#{title}%"))
    end

    def add_comment(book_id:, comment:, author:)
      # TODO
    end

    def update_comment(comment_id:, comment:, author:)
      # TODO
    end

    def delete_comment(comment_id:)
      # TODO
    end

    def comments(book_id:)
      # TODO
    end

    def add_book(title:)
      DB[:books].insert(:title => title)
    end

    def delete_book(id:)
      DB[:books].where(id: id).delete
    end
  end
end
