#!/usr/bin/env python3
import glob
import os
import subprocess
import sys
from pathlib import Path

dmodule_path_var = 'DMODULEPATH'


def check_path(path_var):
    if path_var not in os.environ:
        print(path_var + ' is not set', file=sys.stderr)
        sys.exit(-1)


def add_to_envrc(dmodulefile):
    new_env = os.environ.copy()
    new_env["EDITOR"] = f"dm-editor add {dmodulefile}"
    ret = subprocess.run(['direnv', 'edit'], env=new_env,
                         stderr=subprocess.DEVNULL)
    if ret.returncode:
        print('no .envrc found, creating one here', file=sys.stderr)
        subprocess.run(['direnv', 'edit', '.'], env=new_env)


def avail(args):
    check_path(dmodule_path_var)
    for path in os.environ[dmodule_path_var].split(':'):
        path = Path(path)
        files = sorted(path.glob('**/*'))
        for f in files:
            print(f.relative_to(path))
    return 0


def usage(args):
    print('coming soon...', file=sys.stderr)


def list_loaded(args):
    # get .envrc by calling EDITOR=echo direnv edit, search .envrc for
    # source_env calls, list those as loaded "dmodulefiles"
    print('coming soon...', file=sys.stderr)


def load(dmodulefiles):
    if len(dmodulefiles) < 1:
        print('dm: please supply the name of a dmodulefile in the form: foo/1.0',
              file=sys.stderr)
        return -1
    any_found = False
    for dmodulefile in dmodulefiles:
        found = False
        for path in os.environ[dmodule_path_var].split(':'):
            full_path = path + '/' + dmodulefiles[0]
            if not os.path.exists(full_path):
                continue
            add_to_envrc(full_path)
            found = True
            any_found = True
        if not found:
            print("dm: error: f{dmodulefile} not found", file=sys.stderr)
    if any_found:
        return 0
    return -1


def purge(args):
    print('coming soon...', file=sys.stderr)


def reload_dmodules(args):
    # just call direnv reload?
    print('coming soon...', file=sys.stderr)


def unload(args):
    # remove corresponding source_env from .envrc
    print('coming soon...', file=sys.stderr)


commands = {
    'a': avail,
    'avail': avail,
    'h': usage,
    'help': usage,
    'ls': list_loaded,
    'list': list_loaded,
    'lo': load,
    'loa': load,
    'load': load,
    'p': purge,
    'purge': purge,
    'r': reload_dmodules,
    'reload': reload_dmodules,
    'u': unload,
    'un': unload,
    'unl': unload,
    'unlo': unload,
    'unloa': unload,
    'unload': unload,
}


def main():
    if len(sys.argv) < 2:
        usage(0)
        return 0
    if sys.argv[1] in commands:
        return commands[sys.argv[1]](sys.argv[2:])
    else:
        print(f'dm: there is no {sys.argv[1]} command', file=sys.stderr)
        return -1


if __name__ == "__main__":
    sys.exit(main())
