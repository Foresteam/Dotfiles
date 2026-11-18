# Oh My Zsh Git plugin shortcuts, converted for Fish.
# The personal aliases in config.fish load later and override matching names.
# Generated from the effective aliases in the current Zsh session.

function git_current_branch
    command git symbolic-ref --quiet --short HEAD 2>/dev/null; or command git rev-parse --short HEAD 2>/dev/null
end

function git_develop_branch
    command git rev-parse --git-dir >/dev/null 2>&1; or return 1
    for branch in dev devel develop development
        if command git show-ref -q --verify refs/heads/$branch
            echo $branch
            return 0
        end
    end
    echo develop
    return 1
end

function git_main_branch
    command git rev-parse --git-dir >/dev/null 2>&1; or return 1
    for prefix in refs/heads refs/remotes/origin refs/remotes/upstream
        for branch in main trunk mainline default stable master
            if command git show-ref -q --verify $prefix/$branch
                echo $branch
                return 0
            end
        end
    end
    for remote in origin upstream
        set -l ref (command git symbolic-ref --quiet --short refs/remotes/$remote/HEAD 2>/dev/null)
        if test -n "$ref"
            string replace "$remote/" "" -- $ref
            return 0
        end
    end
    echo master
    return 1
end

# Direct Git aliases
alias 'ga' 'git add'
alias 'gaa' 'git add --all'
alias 'gam' 'git am'
alias 'gama' 'git am --abort'
alias 'gamc' 'git am --continue'
alias 'gams' 'git am --skip'
alias 'gamscp' 'git am --show-current-patch'
alias 'gap' 'git apply'
alias 'gapa' 'git add --patch'
alias 'gapt' 'git apply --3way'
alias 'gau' 'git add --update'
alias 'gav' 'git add --verbose'
alias 'gb' 'git branch'
alias 'gbD' 'git branch --delete --force'
alias 'gba' 'git branch --all'
alias 'gbd' 'git branch --delete'
alias 'gbl' 'git blame -w'
alias 'gbm' 'git branch --move'
alias 'gbnm' 'git branch --no-merged'
alias 'gbr' 'git branch --remotes'
alias 'gbs' 'git bisect'
alias 'gbsb' 'git bisect bad'
alias 'gbsg' 'git bisect good'
alias 'gbsn' 'git bisect new'
alias 'gbso' 'git bisect old'
alias 'gbsr' 'git bisect reset'
alias 'gbss' 'git bisect start'
alias 'gc' 'git commit --verbose'
alias 'gc!' 'git commit --verbose --amend'
alias 'gcB' 'git checkout -B'
alias 'gca' 'git commit -a --amend -m'
alias 'gca!' 'git commit --verbose --all --amend'
alias 'gcam' 'git commit --all --message'
alias 'gcan!' 'git commit --verbose --all --no-edit --amend'
alias 'gcann!' 'git commit --verbose --all --date=now --no-edit --amend'
alias 'gcans!' 'git commit --verbose --all --signoff --no-edit --amend'
alias 'gcas' 'git commit --all --signoff'
alias 'gcasm' 'git commit --all --signoff --message'
alias 'gcb' 'git checkout -b'
alias 'gcf' 'git config --list'
alias 'gcfu' 'git commit --fixup'
alias 'gcl' 'git clone --recurse-submodules'
alias 'gclean' 'git clean --interactive -d'
alias 'gclf' 'git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules'
alias 'gcm' 'git commit -a -m'
alias 'gcmsg' 'git commit --message'
alias 'gcn' 'git commit --verbose --no-edit'
alias 'gcn!' 'git commit --verbose --no-edit --amend'
alias 'gco' 'git checkout'
alias 'gcor' 'git checkout --recurse-submodules'
alias 'gcount' 'git shortlog --summary --numbered'
alias 'gcp' 'git cherry-pick'
alias 'gcpa' 'git cherry-pick --abort'
alias 'gcpc' 'git cherry-pick --continue'
alias 'gcs' 'git commit --gpg-sign'
alias 'gcsm' 'git commit --signoff --message'
alias 'gcss' 'git commit --gpg-sign --signoff'
alias 'gcssm' 'git commit --gpg-sign --signoff --message'
alias 'gd' 'git diff'
alias 'gdca' 'git diff --cached'
alias 'gdcw' 'git diff --cached --word-diff'
alias 'gds' 'git diff --staged'
alias 'gdt' 'git diff-tree --no-commit-id --name-only -r'
alias 'gdup' 'git diff @{upstream}'
alias 'gdw' 'git diff --word-diff'
alias 'gf' 'git fetch'
alias 'gfa' 'git fetch --all --tags --prune --jobs=10'
alias 'gfo' 'git fetch origin'
alias 'gg' 'git gui citool'
alias 'gga' 'git gui citool --amend'
alias 'ghh' 'git help'
alias 'gignore' 'git update-index --assume-unchanged'
alias 'gl' 'git log --graph --oneline --decorate'
alias 'glg' 'git log --stat'
alias 'glgg' 'git log --graph'
alias 'glgga' 'git log --graph --decorate --all'
alias 'glgm' 'git log --graph --max-count=10'
alias 'glgp' 'git log --stat --patch'
alias 'glo' 'git log --oneline --decorate'
alias 'glod' 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias 'glods' 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias 'glog' 'git log --oneline --decorate --graph'
alias 'gloga' 'git log --oneline --decorate --graph --all'
alias 'glol' 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias 'glola' 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias 'glols' 'git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias 'gm' 'git merge'
alias 'gma' 'git merge --abort'
alias 'gmc' 'git merge --continue'
alias 'gmff' 'git merge --ff-only'
alias 'gms' 'git merge --squash'
alias 'gmtl' 'git mergetool --no-prompt'
alias 'gmtlvim' 'git mergetool --no-prompt --tool=vimdiff'
alias 'gp' 'git push'
alias 'gpd' 'git push --dry-run'
alias 'gpf' 'git push --force-with-lease --force-if-includes'
alias 'gpf!' 'git push --force'
alias 'gpod' 'git push origin --delete'
alias 'gpr' 'git pull --rebase'
alias 'gpra' 'git pull --rebase --autostash'
alias 'gprav' 'git pull --rebase --autostash -v'
alias 'gprv' 'git pull --rebase -v'
alias 'gpu' 'git push upstream'
alias 'gpv' 'git push --verbose'
alias 'gr' 'git remote'
alias 'gra' 'git remote add'
alias 'grb' 'git rebase'
alias 'grba' 'git rebase --abort'
alias 'grbc' 'git rebase --continue'
alias 'grbi' 'git rebase --interactive'
alias 'grbo' 'git rebase --onto'
alias 'grbs' 'git rebase --skip'
alias 'grev' 'git revert'
alias 'greva' 'git revert --abort'
alias 'grevc' 'git revert --continue'
alias 'grf' 'git reflog'
alias 'grh' 'git reset'
alias 'grhh' 'git reset --hard'
alias 'grhk' 'git reset --keep'
alias 'grhs' 'git reset --soft'
alias 'grm' 'git rm'
alias 'grmc' 'git rm --cached'
alias 'grmv' 'git remote rename'
alias 'grrm' 'git remote remove'
alias 'grs' 'git restore'
alias 'grset' 'git remote set-url'
alias 'grss' 'git restore --source'
alias 'grst' 'git restore --staged'
alias 'gru' 'git reset --'
alias 'grup' 'git remote update'
alias 'grv' 'git remote --verbose'
alias 'gsb' 'git status --short --branch'
alias 'gsd' 'git svn dcommit'
alias 'gsh' 'git show'
alias 'gshs' 'git show --stat'
alias 'gsi' 'git submodule init'
alias 'gsnut' 'git status --untracked-files=no'
alias 'gsps' 'git show --pretty=short --show-signature'
alias 'gsr' 'git svn rebase'
alias 'gss' 'git status --short'
alias 'gst' 'git status'
alias 'gsta' 'git stash push'
alias 'gstaa' 'git stash apply'
alias 'gstall' 'git stash --all'
alias 'gstc' 'git stash clear'
alias 'gstd' 'git stash drop'
alias 'gstl' 'git stash list'
alias 'gstp' 'git stash pop'
alias 'gsts' 'git stash show --patch'
alias 'gsu' 'git submodule update'
alias 'gsuri' 'git submodule update --recursive --init'
alias 'gsw' 'git switch'
alias 'gswc' 'git switch --create'
alias 'gta' 'git tag --annotate'
alias 'gts' 'git tag --sign'
alias 'gunignore' 'git update-index --no-assume-unchanged'
alias 'gwch' 'git log --patch --abbrev-commit --pretty=medium --raw'
alias 'gwt' 'git worktree'
alias 'gwta' 'git worktree add'
alias 'gwtls' 'git worktree list'
alias 'gwtmv' 'git worktree move'
alias 'gwtrm' 'git worktree remove'

# Aliases with dynamic branch names
alias 'gcd' 'git checkout (git_develop_branch)'
alias 'ggpull' 'git pull origin (git_current_branch)'
alias 'ggpush' 'git push origin (git_current_branch)'
alias 'ggsup' 'git branch --set-upstream-to=origin/(git_current_branch)'
alias 'glolm' 'git log (git_main_branch) --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias 'glom' 'git log --oneline --decorate --color (git_main_branch)..'
alias 'gluc' 'git pull upstream (git_current_branch)'
alias 'glum' 'git pull upstream (git_main_branch)'
alias 'gmom' 'git merge origin/(git_main_branch)'
alias 'gmum' 'git merge upstream/(git_main_branch)'
alias 'gprom' 'git pull --rebase origin (git_main_branch)'
alias 'gpromi' 'git pull --rebase=interactive origin (git_main_branch)'
alias 'gprum' 'git pull --rebase upstream (git_main_branch)'
alias 'gprumi' 'git pull --rebase=interactive upstream (git_main_branch)'
alias 'gpsup' 'git push --set-upstream origin (git_current_branch)'
alias 'gpsupf' 'git push --set-upstream origin (git_current_branch) --force-with-lease --force-if-includes'
alias 'grbd' 'git rebase (git_develop_branch)'
alias 'grbm' 'git rebase (git_main_branch)'
alias 'grbmi' 'git rebase (git_main_branch) --interactive'
alias 'grbmia' 'git rebase (git_main_branch) --interactive --autosquash'
alias 'grbom' 'git rebase origin/(git_main_branch)'
alias 'grbum' 'git rebase upstream/(git_main_branch)'
alias 'groh' 'git reset origin/(git_current_branch) --hard'
alias 'gswd' 'git switch (git_develop_branch)'
alias 'gswm' 'git switch (git_main_branch)'

# Other aliases and Git helper functions follow.
alias g git
alias ggpur ggu
alias gstu 'gsta --include-untracked'

function grt
    set -l root (command git rev-parse --show-toplevel 2>/dev/null)
    or set root .
    cd "$root"
end

function _git_gone_branches
    for line in (command env LANG=C git branch --no-color -vv | string match -r '.*: gone\]')
        set -l fields (string split -m1 ' ' -- (string trim -- (string sub -s 3 -- "$line")))
        echo $fields[1]
    end
end

function gbg
    command env LANG=C git branch -vv | command grep ': gone\]'
end

function gbgd
    for branch in (_git_gone_branches)
        command git branch -d "$branch"
    end
end

function gbgD
    for branch in (_git_gone_branches)
        command git branch -D "$branch"
    end
end

function gdct
    set -l tag (command git rev-list --tags --max-count=1)
    or return 1
    command git describe --tags "$tag" $argv
end

function gfg
    command git ls-files | command grep $argv
end

function gignored
    command git ls-files -v | command grep '^[[:lower:]]'
end

function git-svn-dcommit-push
    command git svn dcommit; and command git push github (git_main_branch):svntrunk
end

function gk
    command gitk --all --branches $argv &
end

function gke
    command gitk --all (command git log --walk-reflogs --pretty=%h) $argv &
end

function glp
    if test (count $argv) -gt 0
        command git log --pretty="$argv[1]" $argv[2..-1]
    end
end

function gpoat
    command git push origin --all; and command git push origin --tags
end

function gpristine
    command git reset --hard; and command git clean --force -dfx
end

function gtl
    set -l pattern '*'
    if test (count $argv) -gt 0
        set pattern "$argv[1]*"
    end
    command git tag --sort=-v:refname -n --list "$pattern"
end

function gtv
    command git tag | command sort -V
end

function gunwip
    set -l subject (command git log -1 --format=%s)
    if string match -q '*--wip--*' -- "$subject"
        command git reset HEAD~1
    end
end

function gwip
    command git add -A; or return 1
    command git commit --no-verify --no-gpg-sign --message '--wip-- [skip ci]'
end

function gwipe
    command git reset --hard; and command git clean --force -df
end

function gbcopy
    set -l branch (git_current_branch)
    or return 1
    printf %s "$branch" | command wl-copy
end

function grename
    if test (count $argv) -ne 2
        echo 'Usage: grename old_branch new_branch' >&2
        return 1
    end
    command git branch -m "$argv[1]" "$argv[2]"; or return 1
    command git push origin :"$argv[1]"; and command git push --set-upstream origin "$argv[2]"
end

function gunwipall
    set -l previous (command git log --grep='--wip--' --invert-grep --max-count=1 --format=%H)
    or return 1
    if test -n "$previous"; and test "$previous" != (command git rev-parse HEAD)
        command git reset "$previous"
    end
end

function work_in_progress
    if command git -c log.showSignature=false log -1 --format=%s 2>/dev/null | string match -q '*--wip--*'
        echo 'WIP!!'
    end
end

function ggpnp
    ggl $argv; and ggp $argv
end

function gbda
    set -l main (git_main_branch)
    set -l develop (git_develop_branch)
    set -l current (git_current_branch)
    for branch in (command git branch --format='%(refname:short)' --merged)
        if test "$branch" != "$main"; and test "$branch" != "$develop"; and test "$branch" != "$current"
            command git branch -d "$branch"
        end
    end
end

function gbds
    set -l base (git_main_branch)
    or set base (git_develop_branch)
    for branch in (command git for-each-ref refs/heads/ --format='%(refname:short)')
        if test "$branch" = "$base"; or test "$branch" = (git_current_branch)
            continue
        end
        set -l merge_base (command git merge-base "$base" "$branch")
        or continue
        set -l tree (command git rev-parse "$branch^{tree}")
        or continue
        set -l synthetic (command git commit-tree "$tree" -p "$merge_base" -m _)
        or continue
        if string match -q -- '-*' (command git cherry "$base" "$synthetic")
            command git branch -D "$branch"
        end
    end
end

function gccd
    command git clone --recurse-submodules $argv
    or return 1
    set -l destination $argv[-1]
    if not test -d "$destination"
        set -l parts (string split -r -m1 / -- (string replace -r '\.git$' '' -- "$destination"))
        set destination $parts[-1]
        set parts (string split -r -m1 : -- "$destination")
        set destination $parts[-1]
    end
    cd "$destination"
end

function gdv
    command git diff -w $argv | command view -
end

function gdnolock
    command git diff $argv ':(exclude)package-lock.json' ':(exclude)*.lock'
end

function ggu
    set -l branch (git_current_branch)
    if test (count $argv) -eq 1
        set branch $argv[1]
    end
    command git pull --rebase origin "$branch"
end

function ggl
    if test (count $argv) -eq 0
        command git pull origin (git_current_branch)
    else
        command git pull origin $argv
    end
end

function ggf
    set -l branch (git_current_branch)
    if test (count $argv) -eq 1
        set branch $argv[1]
    end
    command git push --force origin "$branch"
end

function ggfl
    set -l branch (git_current_branch)
    if test (count $argv) -eq 1
        set branch $argv[1]
    end
    command git push --force-with-lease origin "$branch"
end

function ggp
    if test (count $argv) -eq 0
        command git push origin (git_current_branch)
    else
        command git push origin $argv
    end
end
