# Runner

![gif](https://imgur.com/bSnBCD6.gif)

## 1. Installation

### 1.a. Installation with [Vim-Plug](https://github.com/junegunn/vim-plug)
1. Add `Plug 'aben20807/vim-runner'` to your vimrc file.
2. Reload your vimrc or restart.
3. Run `:PlugInstall`

### 1.b. Installation with [Vundle](https://github.com/VundleVim/Vundle.vim)
1. Add `Plugin 'aben20807/vim-runner'` to your vimrc file.
2. Reload your vimrc or restart
3. Run `:PluginInstall`

## 2. Usage

### 2.a. Supported Languages
+ C, C++, Python, Rust, Markdown, Lisp.

### 2.b. Settings

```vim
" Use key mappings setting from this plugin by default.
let g:runner_use_default_mapping = 1

" Save file first before compile and run by default.
let g:runner_is_save_first = 1

" Print a timestamp on the top of output by default.
let g:runner_print_timestamp = 1

" Print time usage of do all actions by default.
let g:runner_print_time_usage = 1

" Show the comment information by default.
let g:runner_show_info = 1

" Not auto remove tmp file by default.
let g:runner_auto_remove_tmp = 0

" Use <F5> to compile and run code by default.
" Feel free to change mapping you like.
let g:runner_run_key = "<F5>"

" Set tmp dir for output.
let g:runner_tmp_dir = "/tmp/vim-runner/"

" Section: work with other plugins
" w0rp/ale
let g:runner_is_with_ale = 0
" iamcco/markdown-preview.vim
let g:runner_is_with_md = 0

" Section: executable settings
let g:runner_c_executable = "gcc"
let g:runner_cpp_executable = "g++"
let g:runner_rust_executable = "cargo"
let g:runner_python_executable = "python3"

" Section: compile options settings
let g:runner_c_compile_options = "-std=c11 -Wall"
let g:runner_cpp_compile_options = "-std=c++14 -Wall"
let g:runner_rust_compile_options = ""

" Section: run options settings
let g:runner_c_run_options = ""
let g:runner_cpp_run_options = ""
let g:runner_rust_run_backtrace = 1
let g:runner_rust_run_options = ""
```
