module Feedback
    
    def Feedback.new(user_id, date_time, feedback_topic, feedback)
        result = false
        insert = "INSERT INTO feedback (feedback_id, user_id, date_time, feedback_topic, feedback) VALUES(?, ?, ?, ?);"
        begin
            $db.execute insert, user_id, date_time, feedback_topic, feedback
            result = true
            puts "Insertion success"
        rescue SQLite3::ConstraintException
            puts "Insertion Failed"
        end
        return result
    end
    
end