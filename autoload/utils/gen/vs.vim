" autoload/gen/vs.vim - contains helpers for Visual Studio generator
" Maintainer:   Ilya Churaev <https://github.com/ilyachur>

" Returns the name of CMake generator
function! utils#gen#vs#getGeneratorName() abort
    return 'Visual Studio'
endfunction

" Returns the default target for current CMake generator
function! utils#gen#vs#getDefaultTarget() abort
    return 'ALL_BUILD'
endfunction

" Returns the clean target for CMake generator
function! utils#gen#vs#getCleanTarget() abort
    return 'clean'
endfunction

" Returns the list of targets for CMake generator
function! utils#gen#vs#getTargets() abort
    " Parse VS projects
    let l:build_dir = utils#cmake#detectBuildDir()
    let l:list_targets = []
    let l:res = split(system('dir *.vcxproj /S /B'), "\n")
    for l:value in l:res
        if l:value !=# ''
            let l:files = split(l:value, l:build_dir)
            if len(l:files) != 2
                continue
            endif
            " Exclude projects from CMakeFiles folder
            let l:files = split(l:files[1], 'CMakeFiles')
            if len(l:files) != 1
                continue
            endif
            let l:files = split(l:files[0], '\\')
            let l:list_targets += [fnamemodify(l:files[-1], ':r')]
        endif
    endfor
    return l:list_targets
endfunction

" Returns the cmake build command for CMake generator
function! utils#gen#vs#getBuildCommand(build_dir, target, make_arguments) abort
    let l:cmd = 'cmake --build ' . utils#fs#fnameescape(a:build_dir) . ' --target ' . a:target . ' -- ' . a:make_arguments
    return l:cmd
endfunction
