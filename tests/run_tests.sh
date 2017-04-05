#!/bin/bash

set -ev

function check_snapweb_is_running {
    LINES=`ps aux | grep snapweb | wc -l`
    if [ $LINES -eq 1 ]
    then
        echo "snapweb is not running"
        exit 1
    else
        echo "OK"
    fi
}

function check_snapweb_is_not_running {
    LINES=`ps aux | grep snapweb | wc -l`
    if [ $LINES -ne 1 ]
    then
        echo "snapweb is running and that was not expected"
        exit 1
    else
        echo "OK"
    fi
}

function check_snapweb_listens {
    let TRIES=30
    while [ $TRIES -ne 0 ]
    do
        LINES=`netstat -tl | grep -e "localhost:5200" -e "localhost:5201" | wc -l`
        if [ $LINES -ne 2 ]
        then
            let TRIES=$TRIES-1
            if [ $TRIES -eq 0 ]
            then 
                echo "Snapweb seems to not be listening the right ports"
                netstat -tl
                exit 1
            else
                # wait some more time to wait for snapweb to be up
                sleep 1
            fi
        else
            echo "OK"
            return 0
        fi
    done
}

function check_snapweb_does_not_listen {
    LINES=`netstat -tl | grep -e "localhost:5200" -e "localhost:5201" | wc -l`
    if [ $LINES -eq 2 ]
    then
        echo "Snapweb seems to be listening"
        netstat -tl
        exit 1
    else
        echo "OK"
    fi
}

# disable the snap
sudo snap disable ubuntu-personal-store >/dev/null

# verify that nothing is listening to the ports snapweb should
check_snapweb_does_not_listen

# enable the snap
sudo snap enable ubuntu-personal-store >/dev/null

# checks snapweb is running
check_snapweb_is_running

# verify that after the installation the ports are now being listened
check_snapweb_listens






