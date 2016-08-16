is_edtf = false

ready = ->
    # Initialize each editor
    $('.edtf-editor').each(() -> 
        editor = $(this)
        input = editor.find('.edtf-input')
        value = editor.find('.edtf-value')
        
        editor.addClass('input-group')
        btnGroup = $('<div></div>').addClass('input-group-btn')
        cal_icon = '<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>'
        edtf_txt = '<small><b>EDTF</b></small>'
        swapBtn = $('<button></button>').addClass('btn btn-default').html(cal_icon)
        swapBtn.click((e) ->
            e.preventDefault()
            is_edtf = !is_edtf
            if !is_edtf
                # standard HTML date editor
                $(this).html(cal_icon)
                input.attr('type', 'date')
            else
                # EDTF text box
                $(this).html(edtf_txt)
                input.attr('type', 'text')
                input.val(value.val())
        )
        
        
        btnGroup.append(swapBtn)
        editor.append(btnGroup)
        
        input.change(() ->
            value.val($(this).val())
        )
    )

$(document).on('turbolinks:load', ready)