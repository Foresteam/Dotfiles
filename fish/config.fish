# ~/.config/fish/config.fish

# ─── Environment ──────────────────────────────────────

set -gx EDITOR vim
set -gx VISUAL vim

set -gx FrameworkPathOverride /Library/Frameworks/Mono.framework/Versions/Current
set -gx ETH enp3s0

set -gx GDK_DPI_SCALE 1
# set -gx GDK_SCALE 2

# Wayland
if test "$XDG_SESSION_TYPE" = wayland
    set -gx MOZ_ENABLE_WAYLAND 1
end

alias server-modpack '/home/foresteam/Applications/ServerPackCreator-9.3.1-x86_64_experimental_ebf2d09e7e04fbb72a83e0b8ffdc00ff.appimage'

# ─── Git aliases ───────────────────────────────────────

alias gce 'git commit -a -m "" --allow-empty-message'
alias gcm 'git commit -a -m'
alias gp 'git push'
alias gpo 'git push origin'
alias gl 'git log --graph --oneline --decorate'
alias gca 'git commit -a --amend -m'
alias gcane 'git commit -a --amend --no-edit'
alias gpall 'git remote | xargs -L1 git push --all'
alias grc 'git rebase --continue'

# Merge branch, then delete it on success
function gmd
    if test (count $argv) -eq 0
        echo "Usage: gmd <branch>"
        return 1
    end

    git merge $argv[1]; and git branch -d $argv[1]
end

# ─── Fastfetch ──────────────────────────────────────
alias fastfetch fastfetch-responsive

# ─── Applications ──────────────────────────────────────

alias what 'niri msg pick-window'

function saveme
    firejail --profile="$HOME/.config/firejail/saveme.profile" $argv
end

alias vue 'pnpm exec vue'
alias jr 'pnpm run'

alias linesall "find . -name '*.*' | xargs wc -l"
alias lines 'wc -l'

alias vscodium '/usr/bin/vscodium --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias chromium '/usr/bin/chromium --enable-features=UseOzonePlatform --ozone-platform=wayland'

alias update-grub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

# ─── Yarn ──────────────────────────────────────────────

fish_add_path -g -p \
    "$HOME/.yarn/bin" \
    "$HOME/.config/yarn/global/node_modules/.bin"

# ─── Android SDK ───────────────────────────────────────

set -gx ANDROID_HOME /opt/android-sdk
set -gx ANDROID_SDK_ROOT /opt/android-sdk
set -gx JAVA_HOME /usr/lib/jvm/java-27-openjdk

# Remove old SDK path
set -gx PATH (string match -v -- '/opt/google/android-sdk/' $PATH)
set -gx PATH (string match -v -- '/opt/google/android-sdk' $PATH)

fish_add_path -g -p \
    "$ANDROID_HOME/emulator" \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/cmdline-tools/latest/bin"

function runavd
    "$HOME/Android/Sdk/emulator/emulator" @Pixel_5_API_29 $argv
end

# ─── pnpm ──────────────────────────────────────────────

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -g -p "$PNPM_HOME"

# ─── fnm (Fast Node Manager) ───────────────────────────

set -l FNM_PATH "$HOME/.local/share/fnm"

if test -d "$FNM_PATH"
    fish_add_path -g -p "$FNM_PATH"

    if command -sq fnm
        fnm env --shell fish | source
    end
end
