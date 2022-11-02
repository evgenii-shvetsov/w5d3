require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
      end
end

class Users
    attr_accessor :id, :fname, :lname
    #User::find_by_name(fname, lname)
    #User.new('fname' => 'Ned', 'lname' => 'Ruggeri', 'is_instructor' => true)
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        person = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM users 
            WHERE id = ?
        SQL
        return nil unless person.length > 0 # person is stored in an array!

        Users.new(person.first)
    end

    def self.find_by_name(fname, lname)
        person_data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT * 
            FROM users 
            WHERE users.fname = fname AND users.lname = lname
        SQL

        return nil unless person_data.length > 0 # person is stored in an array!

        Users.new(person_data) # convert array to a string 
    end

end

class Questions

    attr_accessor :id, :title,:body, :autor_id
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
    end
    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM questions 
            WHERE id = ?
        SQL
        return nil unless data.length > 0 # person is stored in an array!

        Questions.new(data.first)
    end
end

class QuestionFollows
    attr_accessor :id, :question_id, :user_id
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM questions_follows
            WHERE id = ?
        SQL
        return nil unless data.length > 0 # person is stored in an array!

        QuestionFollows.new(data.first)
    end
end

class Replies
    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @user_id = options['user_id']
        @body = oprions['body']
    end
    #find_by_id
    def self.find_by_id(id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM replies 
            WHERE id = ?
        SQL
        return nil unless replies.length > 0 # person is stored in an array!

        Users.new(replies.first)
    end
end

class QuestionLikes
    attr_accessor :id, :question_id, :liker_id
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @liker_id = options['liker_id']
    end

    #find_by_id
    def self.find_by_id(id)
        question_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM question_likes 
            WHERE id = ?
        SQL
        return nil unless question_likes.length > 0 # person is stored in an array!

        Users.new(question_likes.first)
    end
end