# Inspired by:
# http://stackoverflow.com/questions/6637341/use-tab-to-indent-in-textarea

$(document).delegate('.md-editor', 'keydown', (e) ->
    keyCode = e.keyCode || e.which;

    if keyCode == 9
        e.preventDefault();
        start = $(this).get(0).selectionStart;
        end = $(this).get(0).selectionEnd;
        # could also use \t, but we use spaces in this house
        tabVal = "    ";

        # set textarea value to: text before caret + tab + text after caret
        $(this).val($(this).val().substring(0, start) + tabVal + $(this).val().substring(end));

        # put caret at right position again
        $(this).get(0).selectionStart =
        $(this).get(0).selectionEnd = start + 4;
        )