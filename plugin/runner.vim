" Author: Huang Po-Hsuan <aben20807@gmail.com>
" Filename: runner.vim
" Last Modified: 2018-04-16 17:41:45
" Vim: enc=utf-8

if exists("has_loaded_runner")
    finish
endif
if v:version < 700
    echoerr "Runner: this plugin requires vim >= 7."
    finish
endif
let has_loaded_runner = 1

set shell=/bin/sh
set shellcmdflag=-c


" Section: variable initialization
call runner#InitVariable("g:runner_use_default_mapping", 1)
call runner#InitVariable("g:runner_is_save_first", 1)
call runner#InitVariable("g:runner_print_timestamp", 1)
call runner#InitVariable("g:runner_print_time_usage", 1)
call runner#InitVariable("g:runner_show_info", 1)
call runner#InitVariable("g:runner_auto_remove_tmp", 0)
call runner#InitVariable("g:runner_run_key", "<F5>")
call runner#InitVariable("g:runner_tmp_dir", "/tmp/vim-runner/")

" Section: work with other plugins
" w0rp/ale
call runner#InitVariable("g:runner_is_with_ale", 0)
" iamcco/markdown-preview.vim
call runner#InitVariable("g:runner_is_with_md", 0)

" Section: executable settings
call runner#InitVariable("g:runner_c_executable", "gcc")
call runner#InitVariable("g:runner_cpp_executable", "g++")
call runner#InitVariable("g:runner_rust_executable", "cargo")
call runner#InitVariable("g:runner_python_executable", "python3")
call runner#InitVariable("g:runner_lisp_executable", "sbcl --script")

" Section: compile options settings
call runner#InitVariable("g:runner_c_compile_options", "-std=c11 -Wall")
call runner#InitVariable("g:runner_cpp_compile_options", "-std=c++11 -Wall")
call runner#InitVariable("g:runner_rust_compile_options", "")

" Section: run options settings
call runner#InitVariable("g:runner_c_run_options", "")
call runner#InitVariable("g:runner_cpp_run_options", "")
call runner#InitVariable("g:runner_rust_run_backtrace", 1)
call runner#InitVariable("g:runner_rust_run_options", "")


augroup comment
    autocmd BufEnter,BufRead,BufNewFile * call runner#SetUpOS()
    autocmd BufEnter,BufRead,BufNewFile * call runner#SetUpFiletype(&filetype)
augroup END


" Section: key map設定
function! s:SetUpKeyMap()
    execute "nnoremap <silent> ".g:runner_run_key." :<C-u>call runner#DoAll()<CR>"
endfunction
if g:runner_use_default_mapping
    call s:SetUpKeyMap()
endif
