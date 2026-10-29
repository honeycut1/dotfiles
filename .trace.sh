# Startup tracing: log_startup <file> <enter|exit> appends to ~/.startup-trace.log.
# POSIX sh (sourced from .profile under dash). PATH is logged in full on the first
# call in each process (what it inherited); later calls log only the change:
#   + dir   added      - dir   removed      ~ a:b:c   same entries, new order
log_startup() {
    if [ -n "${EPOCHREALTIME-}" ]; then   # bash 5: no fork of date, ms precision
        _us=${EPOCHREALTIME#*[.,]}
        _ts=$(printf '%(%Y-%m-%d %H:%M:%S)T' "${EPOCHREALTIME%[.,]*}").${_us%???}
    else                                  # sh/dash/bash 3.2: whole seconds
        _ts=$(date "+%Y-%m-%d %H:%M:%S")
    fi
    {
        echo "--- $_ts | $1 ($0) | $2"
        if [ -z "${_trace_path+x}" ]; then
            echo "$PATH" | tr ':' '\n' | sed 's/^/  /'
        elif [ "$_trace_path" != "$PATH" ]; then
            _changed=
            _ifs=$IFS; IFS=:
            for _d in $PATH; do
                case ":$_trace_path:" in *":$_d:"*) ;; *) echo "  + $_d"; _changed=1 ;; esac
            done
            for _d in $_trace_path; do
                case ":$PATH:" in *":$_d:"*) ;; *) echo "  - $_d"; _changed=1 ;; esac
            done
            IFS=$_ifs
            [ -n "$_changed" ] || echo "  ~ $PATH"
        fi
    } >> ~/.startup-trace.log
    _trace_path=$PATH
    unset _us _ts _d _ifs _changed
}
