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

let s:navmode_pos = []

" Navmode()
" Start navigation mode
" Arg: optional first motion
function! Navmode(...)
    if !exists('w:navmode')
        let w:navmode = 1
        let s:navmode_pos = getpos('.')
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
    if (strlen(c) == 1 && stridx('jkudeytbm''', c) != -1)
                \ || rc == "\<Up>"     || rc == "\<Down>"
                \ || rc == "\<Left>"   || rc == "\<Right>"
                \ || rc == "\<PageUp>" || rc == "\<PageDown>"
                \ || rc == "\<Home>"   || rc == "\<End>"
        " looping branch
        let feedstr = ":\<C-u>call Navmode()\<cr>"
        if c == 'j' || c == 'd' || rc == "\<Down>"
            if line('.') < line('$')
                let feedstr = "\<C-d>" . feedstr
            endif
        elseif c == 'k' || c == 'u' || rc == "\<Up>"
            if line('.') > 1
                let feedstr = "\<C-u>" . feedstr
            endif
        elseif c == 'e'
            let feedstr = "\<C-e>" . feedstr
        elseif c == 'y'
            let feedstr = "\<C-y>" . feedstr
        elseif c == 't' || rc == "\<Home>" || rc == "\<Left>"
            let feedstr = "gg" . feedstr
        elseif c == 'b' || rc == "\<End>" || rc == "\<Right>"
            let feedstr = "G" . feedstr
        elseif c == 'm' || c == ''''
            let rc2 = getchar()
            let c2  = nr2char(rc2)
            if c2 =~ '\a'
                let feedstr = c . c2 . feedstr
            endif
        else
            let feedstr = rc . feedstr
        endif
        call feedkeys(feedstr, fkmode)
        return ''
    else
        " exit branch
        if c == ' '
            " exit on space
        elseif rc == "\<Bs>"
            " return on starting point with Backspace
            call setpos('.', s:navmode_pos)
        else
            call feedkeys(c)
        endif
        echo ""
        unlet w:navmode
        return ''
    endif
endfun
