#!/usr/bin/env sh

url="http://$GF_SECURITY_ADMIN_USER:$GF_SECURITY_ADMIN_PASSWORD@localhost:3000"

post() {
    curl -s -X POST -d "$1" \
        -H 'Content-Type: application/json;charset=UTF-8' \
        "$url$2" 2> /dev/null
}

if [ ! -f "/var/lib/grafana/.init" ]; then
    # start grafana in background
    ./run.sh $@ &
    # and remember the process id to kill it after installing datasources
    runpid=$!

    until curl -s "$url/api/datasources" 2> /dev/null; do
        sleep 1
    done

    for datasource in /etc/grafana/datasources/*; do
        post "$(envsubst < $datasource)" "/api/datasources"
    done

    touch "/var/lib/grafana/.init"

    # kill grafana process and wait till exit 1
    kill $runpid &
    wait
fi

exec /run.sh $@
