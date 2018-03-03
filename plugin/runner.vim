" Author: Huang Po-Hsuan <aben20807@gmail.com>
" Filename: runner.vim
" Last Modified: 2018-03-03 21:54:11
" Vim: enc=utf-8

" Function: s:InitVariable() function
" 初始化變數
" Ref: https://github.com/scrooloose/nerdcommenter/blob/master/plugin/NERD_commenter.vim#L26
" Args:
"   -var: the name of the var to be initialised
"   -value: the value to initialise var to
"
" Returns:
"   1 if the var is set, 0 otherwise
function! s:InitVariable(var, value)
    if !exists(a:var)
        execute 'let ' . a:var . ' = ' . "'" . a:value . "'"
        return 1
    endif
    return 0
endfunction

" Section: variable initialization
call s:InitVariable("g:runner_use_default_mapping", 1)
call s:InitVariable("g:runner_is_save_first", 1)
call s:InitVariable("g:runner_is_with_ale", 1)
call s:InitVariable("g:runner_print_timestamp", 1)
call s:InitVariable("g:runner_print_time_usage", 1)
call s:InitVariable("g:runner_show_info", 1)
call s:InitVariable("g:runner_run_key", "<F5>")

call s:InitVariable("g:runner_c_executable", "gcc")
call s:InitVariable("g:runner_cpp_executable", "g++")
call s:InitVariable("g:runner_rust_executable", "cargo")
call s:InitVariable("g:runner_python_executable", "python3")

call s:InitVariable("g:runner_c_options", "-std=c11")
call s:InitVariable("g:runner_cpp_options", "-std=c++14")


augroup comment
    autocmd BufEnter,BufRead,BufNewFile * call s:SetUpFiletype(&filetype)
augroup END

" Function: s:SetUpFiletype(filetype) function
" Set up filetype.
" Args:
"   -filetype
function! s:SetUpFiletype(filetype)
    let b:ft = a:filetype
endfunction

" Function: s:ShowInfo(str) function
" Use to print info string.
"
" Args:
"   -str: string need to print.
function! s:ShowInfo(str)
    if g:runner_show_info
        redraw
        echohl WarningMsg
        echo a:str
        echohl NONE
    else
        return
    endif
endfunction

function! DoAll()
    call s:Before()
    call s:Compile()
    call s:Run()
    call s:After()
endfunction

function! s:Before()
    if g:runner_is_save_first
        execute "up"
    endif
    if g:runner_is_with_ale
        let b:runner_ale_status = get(g:, 'ale_enabled', 1)
        let g:ale_enabled = 0
    endif
    if g:runner_print_timestamp
        silent execute "!echo -e '\033[31m' "
        silent execute '!printf "\%35s\\n" "$(date)"'
        silent execute "!echo -e '\033[0m'"
        execute "!echo -e ''"
    endif
endfunction

function! s:Compile()
    if b:ft ==# 'c'
        call s:ShowInfo("c")
    elseif b:ft ==# 'cpp'
        call s:ShowInfo("cpp")
    elseif b:ft ==# 'rust'
        call s:ShowInfo("rust")
    elseif b:ft ==# 'python'
        call s:ShowInfo("python")
    endif
endfunction

function! s:Run()

endfunction

function! s:After()
    if g:runner_is_with_ale
        let g:ale_enabled = b:runner_ale_status
    endif
endfunction

" display date, compile and run
map <F5> :call DoAll()<CR>
" map <F5> :call CompileAndRun()<CR>

" save -> close ALE -> print date -> [execute] run -> open ALE
function! CompileAndRun()
    " save only when changed
    execute "up"
    execute "ALEDisable"
    if &filetype == 'markdown'
        " markdown preview
        try
            " Stop before starting and handle exception
            execute "MarkdownPreviewStop"
        catch /^Vim:E492:/
            execute "MarkdownPreview"
        endtry
    else
        " echo date time
        silent execute "!echo"
        silent execute "!echo -e '\033[31m ╔══════════════════════════════╗' "
        silent execute "!echo -n ' ║ '"
        silent execute "!echo -n `date`"
        silent execute "!echo    ' ║ '"
        silent execute "!echo -e '\033[31m ╚══════════════════════════════╝' \033[37m"
        " detect file type
        if &filetype == 'rust'
            " execute "!rustc % && time ./%< && rm %<"
            execute "!time RUST_BACKTRACE=1 cargo run"
        elseif &filetype == 'c'
            execute "!gcc -std=c11 % -o /tmp/a.out && time /tmp/a.out"
        elseif &filetype == 'cpp'
            execute "!g++ -lm -lcrypt -O2 -std=c++11 -pipe -DONLINE_JUDGE % -o /tmp/a.out && time /tmp/a.out"
        elseif &filetype == 'java'
            execute "!javac -encoding utf-8 %"
            execute "!time java %<"
        elseif &filetype == 'sh'
            :!%
        elseif &filetype == 'python'
            execute "!time python3 %"
        else
            redraw
            echohl WarningMsg
            echo strftime("   ❖  不支援  ❖ ")
            echohl NONE
        endif
    endif
    execute "ALEEnable"
endfunction
