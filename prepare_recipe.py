import os
import sys
import subprocess
from datetime import datetime

from jinja2 import Template


def prepare_recipe(package):

    with open('recipes/{0}/meta.yaml'.format(package)) as f:
        content = f.read()

    os.chdir(package)
    overall_version = subprocess.check_output('python setup.py --version', shell=True).decode('ascii')
    utime = subprocess.check_output('git log -1 --pretty=format:%ct', shell=True).decode('ascii')
    chash = subprocess.check_output('git log -1 --pretty=format:%h', shell=True).decode('ascii')
    os.chdir('..')

    stamp = datetime.fromtimestamp(int(utime)).strftime('%Y%m%d%H%M%S')

    overall_version = overall_version.strip().split('.dev')[0]

    version = overall_version + '.dev' + stamp + '.' + chash

    recipe = Template(content).render(version=version)

    with open('recipes/{0}/meta.yaml'.format(package), 'w') as f:
        f.write(recipe)


def main(*packages):
    for package in packages:
        prepare_recipe(package)


if __name__ == "__main__":
    main(*sys.argv[1:])