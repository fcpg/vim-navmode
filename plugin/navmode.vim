" navmode.vim - Navigation mode
" Author:       fcpg
" Version:      1.0

if exists("g:loaded_navmode") || &cp || v:version < 700
  finish
endif
let g:loaded_navmode = 1

if !exists("g:navmode_noremap")
    let g:navmode_noremap = 1
endif

if !exists("g:navmode_mark")
    let g:navmode_mark = 'n'
endif


function! Navmode(...)
    if !exists('w:navmode')
        let w:navmode = 1
        exe 'mark' g:navmode_mark
    endif
    echoh MoreMsg | unsilent echo "-- NAVIGATE --" | echoh None
    redraw
    if a:0
        let rc = ''
        let c  = a:1
    else
        let rc = getchar()
        let c  = nr2char(rc)
    endif
    let fkmode = g:navmode_noremap ? 'n' : 'm'
    if strlen(c) == 1 && stridx('jkudeytb''', c) != -1
        " looping branch
        let feedstr = ":\<C-u>call Navmode()\<cr>"
        if c == 'j' || c == 'd'
            if line('.') < line('$')
                let feedstr = "\<C-d>" . feedstr
            endif
        elseif c == 'k' || c == 'u'
            if line('.') > 1
                let feedstr = "\<C-u>" . feedstr
            endif
        elseif c == 'e'
            let feedstr = "\<C-e>" . feedstr
        elseif c == 'y'
            let feedstr = "\<C-y>" . feedstr
        elseif c == 't'
            let feedstr = "gg" . feedstr
        elseif c == 'b'
            let feedstr = "G" . feedstr
        elseif c == ''''
            let feedstr = "''" . feedstr
        endif
        call feedkeys(feedstr, fkmode)
        return ''
    else
        " exit branch
        if c == ' '
            " exit on space
        elseif rc == "\<Bs>"
            " return on starting point with Backspace
            call feedkeys("g'" . g:navmode_mark, fkmode)
        else
            call feedkeys(c)
        endif
        echo ""
        unlet w:navmode
        return ''
    endif
endfun
