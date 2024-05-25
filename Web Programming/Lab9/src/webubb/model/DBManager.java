package webubb.model;

import webubb.domain.Asset;
import webubb.domain.Comment;
import webubb.domain.Topic;
import webubb.domain.User;

import java.sql.*;
import java.util.ArrayList;

public class DBManager {
    private Statement statement;

    public DBManager() {
        connect();
    }

    public void connect() {
        try {
            Class.forName("org.gjt.mm.mysql.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost/web_programming_java_assignment",
                    "root",
                    "");
            statement = con.createStatement();
        } catch(Exception error) {
            System.out.println("eroare la connect:"+error.getMessage());
            error.printStackTrace();
        }
    }

    public User authenticate(String username, String password) {
        ResultSet resultSet;
        User user = null;
        System.out.println(username+" "+password);
        try {
            resultSet = statement.executeQuery("select * from users where username='"+username+"' and password='"+password+"'");
            if (resultSet.next()) {
                user = new User(resultSet.getInt("id"), resultSet.getString("username"), resultSet.getString("password"));
            }
            resultSet.close();
        } catch (SQLException error) {
            error.printStackTrace();
        }
        return user;
    }

    public ArrayList<Topic> getTopics() {
        ArrayList<Topic> topics = new ArrayList<Topic>();
        ResultSet resultSet;
        try {
            resultSet = statement.executeQuery("select * from topics");
            while (resultSet.next()) {
                topics.add(new Topic(
                        resultSet.getInt("id"),
                        resultSet.getString("name")
                ));
            }
            resultSet.close();
        } catch (SQLException error) {
            error.printStackTrace();
        }
        return topics;
    }

    public boolean addTopic(String topicName) {
        int result = 0;
        try {
            result = statement.executeUpdate("insert into topics (name) values ('"+topicName+"')");
            System.out.println(result);
        } catch (SQLException error) {
            error.printStackTrace();
        }
        if (result > 0) {
            return true;
        } else {
            return false;
        }
    }

    public boolean addComment(String commentName, int topicId, int userId) {
        int result = 0;
        try {
            result = statement.executeUpdate("insert into comments (text, topic_id, user_id) values ('"+commentName+"', "+topicId+", "+userId+")");
            System.out.println(result);
        } catch (SQLException error) {
            error.printStackTrace();
        }
        if (result > 0) {
            return true;
        } else {
            return false;
        }
    }

    public boolean deleteComment(int commentId) {
        int result = 0;
        try {
            result = statement.executeUpdate("delete from comments where id="+commentId);
            System.out.println(result);
        } catch (SQLException error) {
            error.printStackTrace();
        }
        if (result > 0) {
            return true;
        } else {
            return false;
        }
    }

    public ArrayList<Comment> getCommentsOfTopic(int topicId) {
        ArrayList<Comment> comments = new ArrayList<>();
        ResultSet rs;
        try {
            rs = statement.executeQuery("select * from comments where topic_id="+topicId);
            while (rs.next()) {
                comments.add(new Comment(
                        rs.getInt("id"),
                        rs.getInt("topic_id"),
                        rs.getInt("user_id"),
                        rs.getString("text")
                ));
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }
}