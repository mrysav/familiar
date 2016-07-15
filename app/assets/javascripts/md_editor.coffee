# Inspired by:
# http://stackoverflow.com/questions/6637341/use-tab-to-indent-in-textarea

$(document).delegate('.md-editor', 'keydown', (e) ->
    keyCode = e.keyCode || e.which;

    start = $(this).get(0).selectionStart;
    end = $(this).get(0).selectionEnd;

    # could also use \t, but we use spaces in this house
    tabVal = "    ";
    tabLen = tabVal.length;

    if keyCode == 9
        e.preventDefault();

        # set textarea value to: text before caret + tab + text after caret
        $(this).val($(this).val().substring(0, start) + tabVal + $(this).val().substring(end));

        # put caret at right position again
        $(this).get(0).selectionStart =
        $(this).get(0).selectionEnd = start + tabLen;
    
    if keyCode == 37 && start == end && start >= tabLen && $(this).val().substring(start-tabLen, start) == "    "
        e.preventDefault();
        $(this).get(0).selectionStart = start - tabLen;
        $(this).get(0).selectionEnd = start - tabLen;
        
    if keyCode == 39 && start == end && $(this).val().substring(start, start+tabLen) == "    "
        e.preventDefault();
        $(this).get(0).selectionStart = start + tabLen;
        $(this).get(0).selectionEnd = start + tabLen;
        
    if keyCode == 8 && start == end && start >= tabLen && $(this).val().substring(start-tabLen, start) == "    "
        e.preventDefault();
        
        $(this).val($(this).val().substring(0, start-tabLen) + $(this).val().substring(start));
        
        $(this).get(0).selectionStart =
        $(this).get(0).selectionEnd = start - tabLen;
    
)