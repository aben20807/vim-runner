" Author: Huang Po-Hsuan <aben20807@gmail.com>
" Filename: runner.vim
" Last Modified: 2018-03-04 12:08:33
" Vim: enc=utf-8

if exists("has_loaded_runner")
    finish
endif
if v:version < 700
    echoerr "Runner: this plugin requires vim >= 7."
    finish
endif
let has_loaded_runner = 1

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
call s:InitVariable("g:runner_print_timestamp", 1)
call s:InitVariable("g:runner_print_time_usage", 1)
call s:InitVariable("g:runner_show_info", 1)
call s:InitVariable("g:runner_auto_remove_tmp", 0)
call s:InitVariable("g:runner_run_key", "<F5>")
call s:InitVariable("g:runner_tmp_dir", "/tmp/vim-runner/")

" Section: work with other plugins
" w0rp/ale
call s:InitVariable("g:runner_is_with_ale", 0)
" iamcco/markdown-preview.vim
call s:InitVariable("g:runner_is_with_md", 0)

" Section: executable settings
call s:InitVariable("g:runner_c_executable", "gcc")
call s:InitVariable("g:runner_cpp_executable", "g++")
call s:InitVariable("g:runner_rust_executable", "cargo")
call s:InitVariable("g:runner_python_executable", "python3")

" Section: compile options settings
call s:InitVariable("g:runner_c_options", "-std=c11 -Wall")
call s:InitVariable("g:runner_cpp_options", "-std=c++14 -Wall")


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

" Ref: http://vim.wikia.com/wiki/Automatically_create_tmp_or_backup_directories
function s:InitTmpDir()
    let b:tmp_dir = g:runner_tmp_dir
    if !isdirectory(b:tmp_dir)
        call mkdir(b:tmp_dir)
    endif
endfunction

function! DoAll()
    call s:Before()
    call s:Compile()
    call s:Run()
    call s:After()
endfunction

function! s:Before()
    call s:InitTmpDir()
    if g:runner_is_save_first
        execute "up"
    endif
    if g:runner_is_with_ale
        let b:runner_ale_status = get(g:, 'ale_enabled', 1)
        let g:ale_enabled = 0
    endif
    if g:runner_print_timestamp && b:ft !=# 'markdown'
        silent execute "!echo -e '\033[31m' "
        silent execute '!printf "\%35s" "$(date)"'
        silent execute "!echo -e '\033[0m'"
        if b:ft !=# 'c' && b:ft !=# 'cpp' && b:ft !=# 'rust'
                    \ && b:ft !=# 'python'
            execute "!echo -e ''"
        endif
    endif
endfunction

function! s:Compile()
    let b:tmp_name = strftime("%s")
    if b:ft ==# 'c'
        call s:ShowInfo(b:tmp_name)
        silent execute "!" . g:runner_c_executable . " " .
                    \ g:runner_c_options .
                    \ " % -o " .
                    \ b:tmp_dir .
                    \ b:tmp_name .
                    \ ".out"
    elseif b:ft ==# 'cpp'
        call s:ShowInfo("cpp")
        silent execute "!" . g:runner_cpp_executable . " " .
                    \ g:runner_cpp_options .
                    \ " % -o " .
                    \ b:tmp_dir .
                    \ b:tmp_name .
                    \ ".out"
    elseif b:ft ==# 'rust'
        call s:ShowInfo("rust")
    elseif b:ft ==# 'python'
        call s:ShowInfo("python")
    endif
endfunction

function! s:Run()
    if b:ft ==# 'c'
        call s:ShowInfo("c")
        execute "!time " .
                    \ b:tmp_dir .
                    \ b:tmp_name .
                    \ ".out"
    elseif b:ft ==# 'cpp'
        call s:ShowInfo("cpp")
        execute "!time " .
                    \ b:tmp_dir .
                    \ b:tmp_name .
                    \ ".out"
    elseif b:ft ==# 'rust'
        call s:ShowInfo("rust")
    elseif b:ft ==# 'python'
        call s:ShowInfo("python")
        execute "!time " .
                    \ g:runner_python_executable .
                    \ " %"
    elseif b:ft ==# 'markdown'
        " markdown preview
        try
            " Stop before starting and handle exception
            execute "MarkdownPreviewStop"
        catch /^Vim:E492:/
            execute "MarkdownPreview"
        endtry
    endif
endfunction

function! s:After()
    if (b:ft ==# 'c' || b:ft ==# 'cpp') && g:runner_auto_remove_tmp
        silent execute "!rm " .
                    \ b:tmp_dir .
                    \ b:tmp_name .
                    \ ".out"
    endif
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
