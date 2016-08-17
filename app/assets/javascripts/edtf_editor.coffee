cal_icon = '<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>'
edtf_txt = '<small><b>EDTF</b></small>'

swap = (is_edtf, button, input, value) ->
    if !is_edtf
        # standard HTML date editor
        button.html(cal_icon)
        value.val(input.val())
        input.attr('type', 'date')
    else
        # EDTF text box
        button.html(edtf_txt)
        input.attr('type', 'text')
        input.val(value.val())

ready = ->
    # Initialize each editor
    $('.edtf-editor').each(() -> 
        editor = $(this)
        input = editor.find('.edtf-input')
        value = editor.find('.edtf-value')
        is_edtf = false
        is_edtf = true if value.val() != input.val()
        
        editor.addClass('input-group')
        btnGroup = $('<div></div>').addClass('input-group-btn')
        
        swapBtn = $('<button></button>').addClass('btn btn-default').html(cal_icon)
        swapBtn.click((e) ->
            e.preventDefault()
            is_edtf = !is_edtf
            swap(is_edtf, $(this), input, value)
        )
        
        btnGroup.append(swapBtn)
        editor.append(btnGroup)
        
        swap(is_edtf, swapBtn, input, value)
    )

$(document).on('turbolinks:load', ready)