" navmode.vim - Navigation mode
" Author:       fcpg
" Version:      1.0

if exists("g:loaded_navmode") || &cp || v:version < 700
  finish
endif
let g:loaded_navmode = 1

" Prevent remaps in navmode (ie. feedkeys)
if !exists("g:navmode_noremap")
    let g:navmode_noremap = 1
endif

" Navmode default maps
let s:navmode_default_map = {
            \ 'j':           "call NavmodePageDown()",
            \ 'd':           "call NavmodePageDown()",
            \ "\<Down>":     "call NavmodePageDown()",
            \ "\<PageDown>": "call NavmodePageDown()",
            \ 'k':           "call NavmodePageUp()",
            \ 'u':           "call NavmodePageUp()",
            \ "\<Up>":       "call NavmodePageUp()",
            \ "\<PageUp>":   "call NavmodePageUp()",
            \ 'e':           "call NavmodeLineUp()",
            \ 'y':           "call NavmodeLineDown()",
            \ 't':           "call NavmodeTop()",
            \ "\<Home>":     "call NavmodeTop()",
            \ "\<Left>":     "call NavmodeFeedkeys('[''')",
            \ 'b':           "call NavmodeBottom()",
            \ "\<End>":      "call NavmodeBottom()",
            \ "\<Right>":    "call NavmodeFeedkeys(']''')",
            \ 'm':           "call NavmodeMark()",
            \ '''':          "call NavmodeJump()",
            \ "\<Bs>":       "call NavmodeCancel()",
            \ ' ':           '',
            \}

if !exists("g:navmode_no_default_map")
    if !exists("g:navmode_map")
        let g:navmode_map = {}
    endif
    call extend(g:navmode_map, s:navmode_default_map, 'keep')
endif

" String constant appended to feedkeys() arg so as to stay in navmode
let s:feedstr_lo  = ":\<C-u>call Navmode()\<cr>"

" Start navigation mode
" Arg: optional first motion
function! Navmode(...)
    if !exists('w:navmode_pos')
        let w:navmode_pos = getpos('.')
    endif
    echoh MoreMsg | unsilent echo "-- NAVIGATE --" | echoh None
    redraw
    if a:0
        let c  = a:1
    else
        let rc = getchar()
        let c  = rc =~ '^\d\+$' ? nr2char(rc) : rc
    endif
    " will exit unless set back in next exe call
    let w:navmode = 0
    if has_key(g:navmode_map, c)
        exe g:navmode_map[c]
    else
        call feedkeys(c)
    endif
    if !w:navmode
        echo ""
        unlet w:navmode
        unlet w:navmode_pos
        return ''
    endif
endfun

" Call feedkeys with 1st arg, and set internal var to stay in navmode 
" Arg: feedstr  the string to pass to feedkeys()
" Arg: fkmode   optional mode for feedkeys() - use g:navmode_noremap if unset
function! NavmodeFeedkeys(feedstr, ...)
    let fkmode = a:0 ? a:1 : (g:navmode_noremap ? 'n' : 'm')
    call feedkeys(a:feedstr . s:feedstr_lo, fkmode)
    let w:navmode = 1
endfun

function! NavmodePageDown()
    let feedstr = line('.') < line('$') ? "\<C-d>" : ""
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodePageUp()
    let feedstr = line('.') > 1 ? "\<C-u>" : ""
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodeLineUp()
    let feedstr = "\<C-e>"
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodeLineDown()
    let feedstr = "\<C-y>"
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodeTop()
    let feedstr = "gg"
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodeBottom()
    let feedstr = "G"
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodeMark()
    let rc = getchar()
    let c  = nr2char(rc)
    let feedstr = c =~ '\a' ? 'm' . c : ''
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodeJump()
    let rc = getchar()
    let c  = nr2char(rc)
    let feedstr = c =~ '\a' ? '''' . c : ''
    call NavmodeFeedkeys(feedstr)
endfun

function! NavmodeCancel()
    call setpos('.', w:navmode_pos)
endfun

