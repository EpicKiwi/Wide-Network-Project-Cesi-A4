if [ "$GNS3URL" == "" ] || [ "$GNS3PROJECT" == "" ]; then
	echo "env GNS3URL and GNS3PROJECT are required"
	exit 1
fi

curl -f "${GNS3URL}/v2/projects/${GNS3PROJECT}" -s > /dev/null

if [ ! $? -eq 0 ]; then
	echo "Can't get project on GNS3 server"
	exit 1
fi

echo "Starting nodes ..."

NODES=""

curl -X POST "${GNS3URL}/v2/projects/${GNS3PROJECT}/nodes/start" -s > /dev/null

while [[ "$NODES" == "" ]] || [[ ! $( echo "$TELNETNODES" | grep "stopped" | sed '/^\s*$/d' | wc -l) -eq 0 ]]; do
	sleep 0.5
	NODES=$(curl "${GNS3URL}/v2/projects/${GNS3PROJECT}/nodes" -s | jq ".[] | .name, .node_id, .status, .console_host, .console, .console_type" -r | sed "N;N;N;N;N;s/\n/\t/g")
	TELNETNODES=$(echo "$NODES" | grep "telnet$")
done

echo "Nodes started"
echo "Flushing configs"

FLUSHID=$(date "+%s-%N")
FILES=$(find ./network -type f | grep .cfg$)
ERROR=0

for file in $FILES ; do
	NODENAME=$(basename "$file" ".cfg")
	NODEINFO=$(echo "$NODES" | grep "^$NODENAME")
	if [ "$NODEINFO" == "" ]; then
		echo "Telnet node $NODENAME not found"
		continue
	fi
	NODEHOST=$(echo "$NODEINFO" | cut -f4)
	NODEPORT=$(echo "$NODEINFO" | cut -f5)

	echo "Flushing $NODENAME"

	result=$((
		echo open "$NODEHOST" "$NODEPORT"
		sleep 0.5
		printf "\n\n\n! FLUSHING ON $NODENAME ($FLUSHID) !\n\n\n" | tr "\n" "\r\n"
		printf $'\cz'
		sleep 0.05
		cat "$file" | iconv -c -t ascii | while read line; do
			echo "$line" | tr "\n" "\r\n"
			sleep 0.1
		done
		printf "\n"
		sleep 0.05
		printf $'\cz'
	) | telnet 2> /dev/null | awk "/! FLUSHING ON $NODENAME \($FLUSHID\) !/,0" | grep -B5 -A2 "^%")

	if [ ! $(echo "$result" | sed '/^\s*$/d' | wc -l) -eq 0 ]; then
		echo "$result"
		echo "Error during flush"
		ERROR=$(expr $ERROR + 1)
	fi

done

if [ $ERROR -eq 0 ]; then
	echo "$(echo "$FILES" | sed '/^\s*$/d' | wc -l) config files flushed"
else
	echo "$ERROR errors during flush"
	exit $(expr $ERROR + 100)
fi