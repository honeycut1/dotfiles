log_startup() {
    {
	    echo "--- $(date "+%Y-%m-%d %H:%M:%S.%3N") | $1:$LINENO ($0) | $2"
        echo "$PATH" | tr ':' '\n'
        echo
    } >> ~/.startup-trace.log
}

