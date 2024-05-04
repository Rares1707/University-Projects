<style>
    form, button {
        max-width: 400px; 
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 5px;
        background-color: #f9f9f9;
    }

    input[type="email"],
    input[type="text"],
    textarea {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #ccc;
        border-radius: 3px;
        font-size: 14px;
    }

    input[type="button"],
    {
        background-color: #007bff;
        border: none;
        border-radius: 3px;
        padding: 10px 20px;
        cursor: pointer;
    }
</style>


<form>
    Author (email): <input type="email" name="author" required><br>
    Title: <input type="text" name="title" required><br>
    Comment: <input type="text" name="comment" required></input><br>
    <input type="button" value='Submit'> </input>
</form>

<button onclick="window.location.href = 'SelectRolePage.html'"> Home </button> 

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script>
    $(document).ready(function () 
    {
        $('input[type="button"]').click(function () 
        {
            const authorInput = $('input[name="author"]').val();
            const titleInput = $('input[name="title"]').val();
            const commentInput = $('input[name="comment"]').val();
            $.post(
                '../Backend/add_record.php',
                {
                    author: authorInput,
                    title: titleInput,
                    comment: commentInput
                },
                function (data, status) 
                {
                    alert('status: ' + status)
                },
            );
        });
    });
</script>



