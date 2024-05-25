<%@ page import="webubb.domain.User" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script src="js/jquery-2.0.3.js"></script>
    <title>Insert title here</title>
    <style>
        .asset-name {
            background-color: cornflowerblue;
            border-right: solid 1px black;
        }
    </style>
</head>
<body>
<%! User user; %>
<%  user = (User) session.getAttribute("user");
    if (user != null) {
        out.println("Welcome "+user.getUsername());
%>
        <br/>
        <section>
            <table id="topics-table">
                <tr><td>Id</td><td>Name</td></tr>
            </table>
        </section>
        <p> Want to add a new topic? </p> <input type="text" id="newTopicInput"> <button id="addTopicButton" type="button">Add topic</button>


        <script>
            function getTopics(callbackFunction) {
                $.getJSON(
                    "TopicsController",
                    { action: 'getAll' },
                    callbackFunction
                );
            }

            function addTopic(name, callbackFunction) {
                $.post("TopicsController",
                    {
                        name: name
                    },
                    callbackFunction
                );
            }

            function seeTopicOf(row) {
                const topicId = row.cells[0].textContent;
                sessionStorage.setItem('currentTopicId', topicId);
                window.location.href='topicView.jsp'
            }

            function constructTopicsTable(){
                getTopics(function(topics) {
                    $("#topics-table").html("");
                    $("#topics-table").append("<tr style='background-color: mediumseagreen'><td>Id</td><td>Title</td></tr>");
                    for(let topic in topics) {
                        let topicId = topics[topic].id;
                        $("#topics-table").append("<tr onclick='seeTopicOf(this)'>" +
                            "<td>" + topics[topic].id + "</td>" +
                            "<td>" + topics[topic].name + "</td>" +
                            "</tr>");

                    }
                })
            }

            $(document).ready(function() {
                constructTopicsTable()

                $("#addTopicButton").click(function() {
                    addTopic($("#newTopicInput").val(), function(response) {
                        console.log(response);
                        constructTopicsTable()
                    })
                    $("#newTopicInput").val("");
                })

                $("#getAssetsbtn").click(function() {
                    getUserAssets(<%= user.getId() %>, function(assets) {
                        console.log(assets);
                    })
                })
            });
        </script>
<%
    }
%>

</body>
</html>