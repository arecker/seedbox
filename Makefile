.PHONY: sync
sync:
	scp ./assume.sh "ebonhawk:~/"
	scp ./kick.sh "ebonhawk:~/"
	scp ./stop.sh "ebonhawk:~/"
	scp ./sync.sh "ebonhawk:~/"
	scp ./transmission.py "ebonhawk:~/"
