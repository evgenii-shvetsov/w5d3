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
    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| Users.new(datum) }
    end

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

    def authored_questions
        Questions.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        QuestionFollows.followed_questions_for_user_id(id)
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

    def self.find_by_author_id(author_id)
        que = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT * 
            FROM questions 
            WHERE author_id = ?
        SQL
        return nil unless que.length > 0

        Questions.new(que.first)
    end

    def author
        Users.find_by_id(id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        QuestionFollows.followers_for_question_id(id)
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
    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT users.*
            FROM users
            JOIN questions_follows
            ON questions_follows.user_id = users.id
            WHERE question_id = ?
        SQL
        return nil unless data.length > 0 # person is stored in an array!
        data.map {|el| Users.new(el)} 
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT questions.*
            FROM questions
            JOIN questions_follows 
            ON questions.id = questions_follows.question_id
            WHERE  user_id = ?
        SQL
        return nil unless data.length > 0 # person is stored in an array!
        data.map {|el| Questions.new(el)} 
    end


end

class Replies
    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @user_id = options['user_id']
        @body = options['body']
    end
    #find_by_id
    def self.find_by_id(id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * 
            FROM replies 
            WHERE id = ?
        SQL
        return nil unless replies.length > 0 # person is stored in an array!

        Replies.new(replies.first)
    end

    def self.find_by_parent_reply_id(parent_reply_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
        SELECT * 
        FROM replies 
        WHERE parent_reply_id = ?
    SQL
    return nil unless replies.length > 0 # person is stored in an array!

    Replies.new(replies.first)
    end

    def self.find_by_user_id(user_id)
        re = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT * 
            FROM replies 
            WHERE user_id = ?
        SQL
        return nil unless re.length > 0 # person is stored in an array!

        Replies.new(re.first)
    end

    def self.find_by_question_id(question_id)
        re = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT * 
            FROM replies 
            WHERE question_id = ?
        SQL
        return nil unless re.length > 0 # person is stored in an array!

        Replies.new(re.first)
    end

    def author
        Users.find_by_id(id)
    end

    def question
        Questions.find_by_id(id)
    end

    def parent_reply
        Replies.find_by_id(parent_reply_id)
    end

    def child_replies
        Replies.find_by_parent_reply_id(id)
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

        QuestionLikes.new(question_likes.first)
    end
end