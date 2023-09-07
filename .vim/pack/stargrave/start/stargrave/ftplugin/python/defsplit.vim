" Python function call splitter
" Maintainer: Sergey Matveev <stargrave@stargrave.org>
" License: GNU General Public License version 3 of the License or later
"
" This plugin splits Python function call on several lines.
"
"   def foobar(self, foo: str, bar: Some[thing, too]) -> None:
" to
"   def foobar(
"           self,
"           foo: str,
"           bar: Some[thing, too],
"   ) -> None:
"
"   foo(bar, baz)[0]
" to
"   foo(
"       bar,
"       baz,
"   )[0]
"
" You can un-split it using :Undefsplit command on the line where
" splitting starts.
"
" :Defsplit has optional argument specifying how many opening round
" parenthesis must be skipped.
" :Defsplit 1 on foo(baz(baz(...))) produces
"    foo(baz(
"        baz(...),
"    ))

function! s:bracket_find(line, offset)
    let possible = []
    for bracket in ["(", "[", "{"]
        let found = stridx(a:line, bracket, a:offset)
        if found != -1 | let possible += [found] | endif
    endfor
    return min(possible)
endfunction

function! s:defsplit(...)
    if a:0 == 0 | let skip = 0 | else | let skip = str2nr(a:1) | endif
    let shift = "    "
    let line = getline('.')
    for i in range(len(line))
        if line[i] != ' '
            let prfx = strpart(line, 0, i)
            if line[i : i+3] ==# "def " ||
                \line[i : i+5] ==# "class " ||
                \line[i : i+9] ==# "async def "
                let shift .= shift
            endif
            break
        endif
    endfor
    let brs = {"(": ")", "[": "]", "{": "}"}
    let brfirst = s:bracket_find(line, 0)
    let brlast = strridx(line, brs[line[brfirst]])
    while skip > 0
        let brfirst = s:bracket_find(line, brfirst + 1)
        let brlast = strridx(line, brs[line[brfirst]], brlast - 1)
        let skip -= 1
    endwhile
    let [curly, round, squar, outbuf] = [0, 0, 0, ""]
    let ready = [strpart(line, 0, brfirst + 1)]
    let trailing_comma = 1
    for c in split(line[brfirst + 1 : brlast-1], '\zs')
        if c ==# '*' | let trailing_comma = 0 | endif
        if outbuf ==# "" && c ==# ' ' | continue | endif
        let outbuf .= c
        if c ==# ',' && !curly && !round && !squar
            let ready = add(ready, prfx . shift . outbuf)
            let outbuf = ""
        elseif c ==# '[' | let squar += 1
        elseif c ==# ']' | let squar -= 1
        elseif c ==# '(' | let round += 1
        elseif c ==# ')' | let round -= 1
        elseif c ==# '{' | let curly += 1
        elseif c ==# '}' | let curly -= 1
        endif
    endfor
    if trailing_comma | let outbuf = outbuf . "," | endif
    let ready = add(ready, prfx . shift . outbuf)
    let ready = add(ready, prfx . strpart(line, brlast))
    call append(line("."), ready)
    normal "_dd
endfunction

command! -nargs=? Defsplit call s:defsplit(<f-args>)
command! Undefsplit normal ^v%$J:keepp s/^\(.*\)\([([{]\) \(.*[^,]\),\?\([)\]}]\)\(.*\)$/\1\2\3\4\5<CR>:keepp s/, \?\([)\]}]\+\)$/\1/e<CR>:<CR>
