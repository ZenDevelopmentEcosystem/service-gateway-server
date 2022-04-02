import shlex
import sys

from pytest_bdd import given, parsers, when


@given('servicegwd', target_fixture='cli_cmd')
def setup_cli(cli_path):
    python_path = sys.executable
    return [python_path, cli_path]


@given(parsers.parse('Environment variable `{variable}={value}`'), target_fixture='environment')
def set_environment(environment, variable, value):
    result = environment.copy()
    result[variable] = value
    return result


@when(parsers.parse('servicegwd run with argument(s) `{args}`'), target_fixture='proc_status')
def cli_run_with_argument(args, timeout, cli_cmd, run_shell):
    cli_cmd.extend(shlex.split(args))
    return run_shell(cli_cmd, timeout)
