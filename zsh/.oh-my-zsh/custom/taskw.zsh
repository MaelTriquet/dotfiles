# -------------------------
# Fuzzy-pick wrapper for task
# -------------------------

# The fuzzy picker (only pending/waiting/active)
_task_fzf_pick() {
  local entry id

  entry=$(
    task status:pending or status:waiting or status:active \
         rc.report.pick.columns=id,description,project,tags,due,status \
         rc.report.pick.labels=ID,Desc,Proj,Tags,Due,Status pick \
    | sed '1d' \
    | fzf --prompt="Pick task: " \
          --height=60% --reverse \
          --preview='task {1} info' \
          --preview-window=right:60%
  )

  id=$(echo "$entry" | awk '{print $1}')
  echo "$id"
}

# Override the task command
task() {
  # If last arg is '?', replace it with a fuzzy-picked ID
  if [[ "${@: -1}" == "0" ]]; then
    local cmd picked
    # remove the last argument ('?')
    cmd=("${@:1:$#-1}")
    picked=$(_task_fzf_pick)

    if [[ -n "$picked" ]]; then
      command task "${cmd[@]}" "$picked"
    else
      echo "No task selected."
    fi

  else
    # No fuzzy placeholder → run task normally
    command task "$@"
  fi
}

