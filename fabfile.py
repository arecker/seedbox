import collections
import logging
import pathlib
import sys

import fabric

logging.basicConfig(format='--> fab: %(message)s')
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


class Runner:
    hide = 'err'

    def __init__(self, connection=None, sudo='', template_dir=''):
        self.password = sudo
        self.connection = connection
        self.template_dir = pathlib.Path(template_dir)

    def sudo(self, cmd):
        self.connection.sudo(cmd, hide=self.hide, password=self.password)

    def run(self, cmd):
        self.connection.run(cmd, hide=self.hide)

    def render(self, name=''):
        with (self.template_dir / name).open('r') as f:
            self.connection.put()


def load_sudo_password():
    sudo_path = pathlib.Path('secrets/sudo')
    assert sudo_path.is_file(), f'{sudo_path} does not exist!'
    logging.info('reading sudo password from %s', sudo_path)
    with sudo_path.open('r') as f:
        return f.read().strip()


VPNCreds = collections.namedtuple('VPNCreds', ['user', 'password'])


def load_vpn_secret():
    creds_path = pathlib.Path('secrets/pia')
    assert creds_path.is_file(), f'{creds_path} does not exist!'
    logging.info('reading vpn password from %s', creds_path)
    with creds_path.open('r') as f:
        contents = f.read().strip().splitlines()
        assert len(
            contents
        ) == 2, f'{creds_path} should have 2 lines, not {len(contents)}'
        return VPNCreds(user=contents[1][7:].strip(), password=contents[0])


@fabric.task
def apply(c):
    runner = Runner(connection=c, sudo=load_sudo_password())

    logger.info('updating packages')
    runner.sudo('apt-get update')

    logger.info('installing packages')
    packages = ' '.join([
        'nftables',
        'openvpn',
        'rsync',
    ])
    runner.sudo(f'apt-get install -y {packages}')

    vpn_creds = load_vpn_secret()
