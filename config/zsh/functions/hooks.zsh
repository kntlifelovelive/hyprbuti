# ~/.config/zsh/functions/hooks.zsh
# Custom hooks for different events

# Before each command
preexec() {
    # Track command start time
    cmd_start_time=$(date +%s)
}

# After each command
precmd() {
    # Calculate command duration
    if [[ -n $cmd_start_time ]]; then
        local duration=$(($(date +%s) - cmd_start_time))
        if [[ $duration -gt 5 ]]; then
            echo "⏱️ Command took ${duration}s"
        fi
        unset cmd_start_time
    fi
}
