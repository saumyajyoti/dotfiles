# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Initialize ble.sh
if [ -f ~/GitHub/akinomyoga/ble.sh/out/ble.sh ]; then
  . ~/GitHub/akinomyoga/ble.sh/out/ble.sh --noattach
  bleopt history_share=1
  ble-bind -f up 'history-search-backward hide-status:immediate-accept:point=end'
  ble-bind -f down 'history-search-forward hide-status:immediate-accept:point=end'
  # FZF Key bindings
  if [ -d ~/GitHub/junegunn/fzf ] ; then
    _ble_contrib_fzf_base=~/GitHub/junegunn/fzf
    ble-import -d contrib/fzf-key-bindings
  fi
fi

# Automatically trim long paths in the prompt
PROMPT_DIRTRIM=3

# Set history lengths
HISTFILE=~/.cache/.bash_history
HISTSIZE=10000
HISTFILESIZE=20000
# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:ll:bg:fg:history:clear:dir"

# Set some handy shell options
# histreedit   - use readline on history
# histverify   - load history line onto readline buffer for editing
# lithist      - save history with newlines instead of ; where possible
# histappend   - append to the history file, don't overwrite it
# dirspell     - correct spelling errors during tab-completion
# cdspell      - correct spelling errors in arguments supplied to cd
# nocaseglob   - case-insensitive globbing (used in pathname expansion)
# globstar     - If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
shopt -s histreedit histverify lithist histappend dirspell cdspell nocaseglob globstar 2>/dev/null

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of common commands
if [ -x /usr/bin/dircolors ]; then
  test -r /etc/DIR_COLORS && eval "$(dircolors -b /etc/DIR_COLORS)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='diff --color=auto'
  alias ip='ip --color=auto'
fi

# Custom Aliases
alias dir='exa -la --icons --git --group-directories-first'
alias :q='exit'
alias h="cd ~"
alias d="cd ~/Desktop"
alias ghd="cd ~/GitHub"
alias acd="cd ~/Documents/Academics"
mkcd() { mkdir -p "$@" && cd "$@"; }
gccd() { git clone "git@github.com:$1/$2.git" && cd $2; }

# Startup info
if [ -f /usr/bin/msys-2.0.dll ]; then
  read msyskernelname msyskernelrelease <<<$(uname -sr)
  echo "Microsoft Windows [Version ${msyskernelname#*-}]
(c) Minimal System 2 - $msyskernelrelease"
elif [ -f /bin/cygwin1.dll ]; then
  read cygkernelname cygkernelrelease <<<$(uname -sr)
  echo "Microsoft Windows [Version ${cygkernelname#*-}]
(c) Cygwin - $cygkernelrelease"
fi

# Enable Starship prompt
[ -f ~/.local/share/starship.bash ] && . ~/.local/share/starship.bash || true

# Attach to ble.sh
[[ ${BLE_VERSION-} ]] && ble-attach || true
