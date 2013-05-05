WORKER_FILE=collection.rb
if [ `pgrep -f $WORKER_FILE | wc -l` = 1 ]; then
	pkill -f $WORKER_FILE
fi
ruby $WORKER_FILE
