package webubb.controller;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import webubb.domain.Comment;
import webubb.domain.Topic;
import webubb.model.DBManager;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class CommentsController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int topicId = Integer.parseInt(request.getParameter("topicId"));

        if (topicId != 0) {
            response.setContentType("application/json");
            DBManager dbmanager = new DBManager();
            ArrayList<Comment> comments = dbmanager.getCommentsOfTopic(topicId);
            JSONArray jsonComments = new JSONArray();
            for (Comment comment : comments) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("id", comment.getId());
                jsonObject.put("user_id", comment.getUserId());
                jsonObject.put("topic_id", comment.getTopicId());
                jsonObject.put("text", comment.getText());
                jsonComments.add(jsonObject);
            }
            PrintWriter out = new PrintWriter(response.getOutputStream());
            out.println(jsonComments.toJSONString());
            out.flush();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String commentText = request.getParameter("text");
        int topicId = Integer.parseInt(request.getParameter("topic_id"));
        int userId = Integer.parseInt(request.getParameter("user_id"));
        DBManager dbmanager = new DBManager();
        boolean result = dbmanager.addComment(commentText, topicId, userId);
        PrintWriter out = new PrintWriter(response.getOutputStream());
        if (result)
        {
            out.println("Topic added successfully");
        } else
        {
            out.println("Could not add the topic");
        }
        out.flush();
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println(request.getParameter("id"));
        int commentId = Integer.parseInt(request.getParameter("id"));
        DBManager dbmanager = new DBManager();
        boolean result = dbmanager.deleteComment(commentId);
        PrintWriter out = new PrintWriter(response.getOutputStream());
        if (result)
        {
            out.println("Comment deleted successfully");
        } else
        {
            out.println("Could not delete the comment");
        }
        out.flush();
    }
}
