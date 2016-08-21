#!/bin/bash
if [[ "$RIAK_PERM_HOME" -eq "" ]]; then
	export RIAK_PERM_HOME=$(dirname $(dirname $(readlink -f $0)))
fi

if [[ "$RIAK_PERM_CONF" -eq "" ]]; then
	export RIAK_PERM_CONF=$RIAK_PERM_HOME/conf
fi

running()
{
  if [ -f "$1" ]
  then
    local PID=$(cat "$1" 2>/dev/null) || return 1
    kill -0 "$PID" 2>/dev/null
    return
  fi
  rm -f "$1"
  return 1
}

JETTY_PORT=8890
JETTY_HOME=$RIAK_PERM_HOME/server
JETTY_BASE=$JETTY_HOME

JETTY_USER=m0r
JETTY_GROUP=m0r
STD_REDIRECT_FILE=$RIAK_PERM_HOME/jetty_${JETTY_PORT}.log
JVM_OPTS="-server -Xms512m -Xmx512m -Duser.country=VN -Duser.language=vi -XX:+StartAttachListener"
RIAK_PERM_OPTS="-Driak_perm.home=$RIAK_PERM_HOME -Driak_perm.conf=$RIAK_PERM_CONF"
JETTY_OPTS="-Djetty.home=$JETTY_HOME -Djetty.base=$JETTY_BASE -Djetty.http.port=$JETTY_PORT"
JETTY_PID=$RIAK_PERM_HOME/jetty_${JETTY_PORT}.pid

case $1 in
	start)
		echo "Start riak_perm service"
      		if running $JETTY_PID ; then
        		echo "Already Running $(cat $JETTY_PID)!"
        		exit 1
      		fi
		touch $JETTY_PID
		chown ${JETTY_USER}.${JETTY_GROUP} $JETTY_PID
		touch $STD_REDIRECT_FILE
		chown ${JETTY_USER}.${JETTY_GROUP} $STD_REDIRECT_FILE
		su $JETTY_USER -s "/bin/bash" -c "java $JVM_OPTS $RIAK_PERM_OPTS $JETTY_OPTS -jar $RIAK_PERM_HOME/server/start.jar > $STD_REDIRECT_FILE 2>&1 &
			disown \$!
          		echo \$! > '$JETTY_PID'
		"
	;;
	stop)
		if [ ! -f "$JETTY_PID" ] ; then
			echo "ERROR: no pid found at $JETTY_PID"
			exit 1
		fi
		PID=$(cat "$JETTY_PID" 2>/dev/null)
      		if [ -z "$PID" ] ; then
        		echo "ERROR: no pid id found in $JETTY_PID"
        		exit 1
      		fi
	     	kill "$PID" 2>/dev/null

      		TIMEOUT=30
      		while running $JETTY_PID; do
        		if (( TIMEOUT-- == 0 )); then
          			kill -KILL "$PID" 2>/dev/null
        		fi
        		sleep 1
      		done
	;;
	*)
		echo "Unknown command, usage: $0 start|stop"
	;;
esac
