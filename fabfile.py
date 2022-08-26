import logging
import pathlib
import sys

import fabric

logging.basicConfig(format='--> fab: %(message)s')
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


class Runner:
    hide = 'err'

    def __init__(self, connection=None, sudo=''):
        self.password = sudo
        self.connection = connection

    def sudo(self, cmd):
        self.connection.sudo(cmd, hide=self.hide, password=self.password)

    def run(self, cmd):
        self.connection.run(cmd, hide=self.hide)


@fabric.task
def apply(c):
    sudo_path = pathlib.Path('./.sudo-password')
    assert sudo_path.is_file(), './.sudo-password does not exist!'

    logging.info('setting sudo password from %s', sudo_path)
    with sudo_path.open('r') as f:
        runner = Runner(connection=c, sudo=f.read().strip())

    logger.info('testing hostname')
    runner.run('hostname')

    logger.info('testing sudo')
    runner.sudo('whoami')

    logger.info('updating packages')
    runner.sudo('apt-get update')

    logger.info('installing openvpn')
    runner.sudo('apt-get install -y openvpn')
