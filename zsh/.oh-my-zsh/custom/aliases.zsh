# function to open cleanly nvim in custom terminal
nvim_new() {
  if [[ -n "$NVIM" ]]; then
    if [[ $@ == "" ]]; then
      ARGS="Untitled"
    else
      ARGS="$@"
    fi
    COMMAND='<Esc><Esc>:cd '$PWD'<CR>:e '$ARGS'<CR>'
    nvim --server "$NVIM" --remote-send "$COMMAND"

  else
    command nvim "$@"
  fi
}

alias v="nvim_new"
alias la="ls -a"
alias c="clear"
alias py="python"
alias cl="wl-copy"
alias ai="/home/mael/.conda/envs/chatbot/bin/python ~/agentic_dev_assistant/main.py"
alias nano="nvim"
