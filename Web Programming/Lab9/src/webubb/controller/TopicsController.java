package webubb.controller;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import webubb.domain.Topic;
import webubb.model.DBManager;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;


public class TopicsController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ((action != null) && action.equals("getAll")) {
            response.setContentType("application/json");
            DBManager dbmanager = new DBManager();
            ArrayList<Topic> topics = dbmanager.getTopics();
            JSONArray jsonTopics = new JSONArray();
            for (Topic topic : topics) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("id", topic.getId());
                jsonObject.put("name", topic.getName());
                jsonTopics.add(jsonObject);
            }
            PrintWriter out = new PrintWriter(response.getOutputStream());
            out.println(jsonTopics.toJSONString());
            out.flush();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String topicName = request.getParameter("name");
        DBManager dbmanager = new DBManager();
        boolean result = dbmanager.addTopic(topicName);
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
}
