#!/bin/bash
set -e

# Initial gemini information
gemini --help &> /dev/null

# Do action with first parameter
if [ "$1" = "bash" ] || [ "$1" = "sh" ]; then
    exec "$@"
elif [ "$1" = "prompt" ]; then
    args=(${@})
    echo "${args[@]:1}" > /tmp/prompt
    gemini -p "$(cat /tmp/prompt)"
elif [ "$1" = "plan" ]; then
    if [ -f /plan/${2} ]; then
        gemini -p "$(cat /plan/${2})"
    else
        echo "'${2}' not in plan folder."
    fi
else
    gemini "${@}"
fi
