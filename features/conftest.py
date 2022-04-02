import pytest
from implementation.package import *  # noqa: F403,F401
from implementation.pip import *  # noqa: F403,F401
from implementation.proc_check import *  # noqa: F403,F401
from implementation.servicegwd import *  # noqa: F403,F401
from implementation.timeout import *  # noqa: F403,F401
from infra import local  # noqa: F401
from run import environment, run_shell, working_directory  # noqa: F401


def pytest_addoption(parser):
    parser.addoption('--cli-path', action='store', help='Path to servicegwd.pyz')
    parser.addoption('--sdist-package-path', action='store', help='Path to sdist package')
    parser.addoption('--wheel-package-path', action='store', help='Path to wheel package')


@pytest.fixture(scope='session')
def cli_path(pytestconfig):
    return pytestconfig.getoption('--cli-path')


@pytest.fixture(scope='session')
def sdist_package_path(pytestconfig):
    return pytestconfig.getoption('--sdist-package-path')


@pytest.fixture(scope='session')
def wheel_package_path(pytestconfig):
    return pytestconfig.getoption('--wheel-package-path')
