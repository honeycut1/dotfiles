log_startup() {
    if [ -n "${EPOCHREALTIME-}" ]; then   # bash 5: no fork of date, ms precision
        _us=${EPOCHREALTIME#*[.,]}
        _ts=$(printf '%(%Y-%m-%d %H:%M:%S)T' "${EPOCHREALTIME%[.,]*}").${_us%???}
    else                                  # sh/dash/bash 3.2: whole seconds
        _ts=$(date "+%Y-%m-%d %H:%M:%S")
    fi
    {
        echo "--- $_ts | $1 ($0) | $2"
        echo "$PATH" | tr ':' '\n'
        echo
    } >> ~/.startup-trace.log
    unset _us _ts
}
