Vim-navmode
============
Navigation mode for Vim:

![navmode_screenshot](doc/navmode_o.png)

Why would you want that? 

Because Vim is about _modal editing_, so as to avoid relegating all commands
to Control-Shift-Meta-Alt-AltGr-LeftPedal modifiers. It turns out that
navigation is an unfortunate source of repeated "chords" (keystrokes with 
modifier): `<C-d>`, `<C-u>`, `<Shift-g>`, `<C-e>`, `<C-y>`...

So navmode lets you move around with single keystrokes, from the comfort of 
your home row.

HowTo
------
1. Map the `Navmode()` function to some convenient key(s)
2. Press that key to start navigation mode
3. Move around with u/d, j/k, e/y, t/b
4. Return to normal mode with `<space>`, or jump back to where you started with 
   `<Backspace>`. Or use any other key (eg. `:`) to exit and execute that 
   command in normal mode.

Key Bindings
-------------
Map the `Navmode()` function in your `.vimrc` Eg.:

```VimL
nmap  ]j  :call Navmode('j')<cr> 
nmap  ]k  :call Navmode('k')<cr> 
```
Installation
-------------
Use your favorite method:
*  [Pathogen][1] - `git clone https://github.com/fcpg/vim-navmode ~/.vim/bundle/vim-navmode`
*  [NeoBundle][2] - `NeoBundle 'fcpg/vim-navmode'`
*  [Vundle][3] - `Plugin 'fcpg/vim-navmode'`
*  manual - copy all of the files into your `~/.vim` directory

Help
-----
Run `:helptags` (or `:Helptags` with Pathogen), then `:help navmode`

[1]: https://github.com/tpope/vim-pathogen
[2]: https://github.com/Shougo/neobundle.vim
[3]: https://github.com/gmarik/vundle
