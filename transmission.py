#!/usr/bin/env python
import logging
import os
import pathlib
import platform
import sys


logger = logging.getLogger(__name__)


def main():
    logger.debug('running with env = %s', os.environ)
    logger.info('starting transmission hook with python v%s (%s)', platform.python_version(), sys.executable)

    # transmission.py: running with env = environ({'SHELL': '/bin/bash', 'TR_TORRENT_HASH': 'ef839d84d113cc35719b6fd616a4d8e220de7d32', 'TR_APP_VERSION': '3.00', 'PWD': '/', 'TR_TORRENT_ID': '1', 'LOGNAME': 'debian-transmission', 'HOME': '/var/lib/transmission-daemon', 'LANG': 'en_GB.UTF-8', 'INVOCATION_ID': '46517256d5ef4c0687363a74f6941639', 'USER': 'debian-transmission', 'NOTIFY_SOCKET': '/run/systemd/notify', 'TR_TORRENT_NAME': 'Napoleon Dynamite (2004) [1080p]', 'SHLVL': '1', 'TR_TORRENT_LABELS': '', 'JOURNAL_STREAM': '8:12880', 'PATH': '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', 'TR_TIME_LOCALTIME': 'Mon Oct  2 15:37:25 2023', 'TR_TORRENT_DIR': '/var/lib/transmission-daemon/downloads', '_': '/home/alex/transmission.py'})


if __name__ == '__main__':
    here = pathlib.Path(__file__).parent
    (here / 'logs').mkdir(exist_ok=True)
    logger.setLevel(logging.DEBUG)
    fh = logging.FileHandler('logs/transmission.log')
    ch = logging.StreamHandler(stream=sys.stderr)
    formatter = logging.Formatter('transmission.py: %(message)s')
    ch.setFormatter(formatter)
    fh.setFormatter(formatter)
    logger.addHandler(ch)
    logger.addHandler(fh)
    # logging.basicConfig(filename='logs/transmission.log', level=logging.DEBUG, format='transmission: %(message)s', filemode='a')
    # logging.basicConfig(stream=sys.stderr, level=logging.INFO, format='transmission: %(message)s')
    main()
