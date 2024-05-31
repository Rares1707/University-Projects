<%@ page import="webubb.domain.Topic" %>
<%@ page import="webubb.domain.User" %><%--
  Created by IntelliJ IDEA.
  User: Rares
  Date: 25.05.2024
  Time: 20:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="js/jquery-2.0.3.js"></script>
</head>
<body>
<section id="comments-section"></section>

<%! User user; %>
<%  user = (User) session.getAttribute("user");
    if (user != null) {
%>

<div id="userId" data-id="<%= user.getId() %>" style="display: none;"></div>

<br/>
<button onclick="window.location.href='succes.jsp'">Back to topics</button>
<section>
    <table id="comments-table">
        <tr><td>Id</td><td>Name</td></tr>
    </table>
</section>
<p> New comment </p> <input type="text" id="newCommentInput"> <button id="addCommentButton" type="button">Add comment</button>

<script>
    // Retrieve the topicId from the session storage
    let topicId = sessionStorage.getItem('currentTopicId');

    let userId = document.getElementById('userId').getAttribute('data-id');

    function getComments(callbackFunction) {
        $.getJSON(
            "CommentsController",
            { topicId: topicId },
            callbackFunction
        );
    }

    function addComment(text, callbackFunction) {
        console.log(text, topicId, userId)
        $.post("CommentsController",
            {
                text: text,
                topic_id: topicId,
                user_id: userId
            },
            callbackFunction
        );
    }

    function deleteComment(commentId, callbackFunction){
        console.log(commentId)
        $.ajax({
            url: "CommentsController?id=" + commentId,
            type: 'DELETE',
            success: function(response) {
                console.log(response);
                callbackFunction()
            }
        });
    }

    function handleRowClick(row) {
        if (userId !== row.cells[3].textContent)
            return

        const commentId = row.cells[0].textContent;
        sessionStorage.setItem('currentCommentId', commentId);

        let deleteConfirmation = confirm("Do you want to delete this comment?");
        if (deleteConfirmation) {
            deleteComment(commentId, constructCommentsTable);
        }
    }

    function constructCommentsTable()
    {
        getComments(function(comments) {
            $("#comments-table").html("");
            $("#comments-table").append("<tr style='background-color: mediumseagreen'><td>Id</td><td>Text</td><td>TopicId</td><td>UserId</td></tr>");
            for(let comment in comments) {
                $("#comments-table").append("<tr onclick='handleRowClick(this)'>" +
                    "<td>" + comments[comment].id + "</td>" +
                    "<td>" + comments[comment].text + "</td>" +
                    "<td>" + comments[comment].topic_id + "</td>" +
                    "<td>" + comments[comment].user_id + "</td>" +
                    "</tr>");
            }
        })
    }

    $(document).ready(function() {
        constructCommentsTable()

        $("#addCommentButton").click(function() {
            addComment($("#newCommentInput").val(), function(response) {
                console.log(response);
                constructCommentsTable()
            })
            $("#newCommentInput").val("");
        })

    });

</script>
</body>
</html>

<%
    }
%>