bindkey -M viins ',a' autosuggest-accept
bindkey -M viins ',w' vi-forward-word

bindkey -M viins ',c' autosuggest-clear

bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

bindkey -M vicmd ' ' autosuggest-execute

sudo_last_command() {
  # Get the last command from history
  local last_cmd=$(fc -ln -1)
  # Replace the buffer with "sudo <last_cmd>"
  BUFFER="sudo $last_cmd"
  # Move cursor to end
  CURSOR=${#BUFFER}
  # Execute it
  zle accept-line
}
zle -N sudo_last_command

# Bind ",s" to run sudo !!
bindkey -M viins ',s' sudo_last_command
bindkey -M vicmd ',s' sudo_last_command
