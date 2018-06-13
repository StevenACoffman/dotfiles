#!/Users/scoffman/.virtualenvs/oldschool/bin/python
"""
let us get some cloud INFOrmation.

requires Python2.x right now
would like to add
"""
# list available environments and their status
# leverages cloudformation

import re
import os
import sys
import time
import fnmatch
import argparse
import subprocess
from glob import glob
from difflib import unified_diff
from boto.cloudformation.connection import CloudFormationConnection


class call(argparse.Action):

    """
    a class to overload action.

    requires __call
    returns nothing
    """

    def __call__(self, parser, namespace, values, option_string=None):
        """
        do the needful.

        return: None.
        """
        do(values, 'all', []).get(values)


class do(object):

    """do the do."""

    def __init__(self, values=None, stack='all', arglist=[]):
        """do class."""
        self.values = values
        self.arglist = arglist
        self.stack = stack
        self.proproot = ('/Users/scoffman/Documents/git/continuous-deployment'
                         '/cfn-templates')

    def get(self, values):
        """
        get the stack info.

        return nothing
        """
        CFC = CloudFormationConnection()
        INFO = {}
        if ('new' or 'all') not in values:
            for stack in values:
                STACKQ = CFC.describe_stacks(stack)
                print('Querying for {}....'.format(stack))
        elif 'new' not in values:
            STACKQ = CFC.describe_stacks()
            print('Querying for all {} stacks....'.format(values))
        else:
            return

        for stack in STACKQ:
            INFO[str(stack.stack_name)] = {}
            for out in stack.outputs:
                # for out in stack.outputs[0:4:3]:
                if 'SecretHashKey' in out.key:
                    INFO[str(stack.stack_name)][str(out.key)] = str(out.value)
        vkey = 'missing'
        for k, v in INFO.iteritems():
            try:
                if len([y for y in re.finditer('-', k)]) > 1:
                    message = 'Substack of {}  '.format(k.split('-')[0])
                else:
                    message = '-s {}'.format(v['SecretHashKey'])
                    vkey = v['SecretHashKey']
                print('Stack: {}\n\t {}\n\n'.format(k, message))
                print('Set LAST_AWS_STACK_KEY env var')
                os.environ["LAST_AWS_STACK_KEY"] = k
            except KeyError as da_erro:
                message = ('\t : {} {}\n'
                           .format(da_erro, 'stack has no key yet...'))
                print message
                os.putenv["LAST_AWS_STACK_KEY"] = 'new'
        return (message, vkey)

    def availableStacks(self):
        """
        find available stacks based on properties files in local path.

        searches paths to find the properties files and then remebers it in a
        .file in your homedir
        returns: list of properties files
        """
        meta_file = "{}/.sit".format(os.path.expanduser("~"))
        properties = []
        dir_paths = [os.path.expanduser("~"), '/var/tmp', '/opt']
        find_ptrn = '*.properties'
        for path in dir_paths:
            for root, dirs, files in os.walk(path):
                for filename in fnmatch.filter(files, find_ptrn):
                    if 'personal' in dirs:
                        properties.append(os.path.join(root, filename))

        print properties
        with open(meta_file, 'w') as mf:
            mf.write(str(properties))
        return properties

    def show_diff(self):
        """
        show the difference for the template files.

        find and show the diff of the files
        """
        for item in ['', '-Platform', '-DSE', '-Services']:
            new_file = './.template-new{}.json'.format(item)
            exs_file = './.template-existing{}.json'.format(item)
            try:
                new_file_data = open(new_file, 'r')
                new_file_time = time.ctime(os.path.getmtime(new_file))
                exs_file_data = open(exs_file, 'r')
                exs_file_time = time.ctime(os.path.getmtime(exs_file))
                file_diff = unified_diff(exs_file_data.readlines(),
                                         new_file_data.readlines())
                new_file_data.close()
                exs_file_data.close()
                print('=~._ {}:{} {} _.~='.format(exs_file_time,
                                                  new_file_time,
                                                  item))
            except Exception as missing:
                print('no {} file: {}'.format(item, missing))
                pass
                continue
            print ''.join(list(file_diff))
            print('\n---------------------------------\n')

    def stackit(self, properties=None, stackkey=None, test=False, delme=False):
        """
        let stacker do java work.

        java -jar ~/github/continuous-deployment/stacker/target/stacker-exec.jar
        """
        stacker = ('{}/../stacker/target/stacker-exec.jar'.format(self.proproot))
        self.arglist.insert(0, 'java')
        self.arglist.insert(1, '-jar')
        self.arglist.insert(2, stacker)
        if stackkey[0] != 'new':
            self.arglist.append('-s {}'.format(stackkey[0]))
        self.arglist.append('-p {}/{}'.format(self.proproot, properties[0]))
        if delme:
            self.arglist.append('-d')
        if test:
            self.arglist.append('-t')
            old_files = glob('.template*')
            print(' Removing old template files {}'.format(old_files))
            try:
                for item in old_files:
                    os.remove(item)
            except Exception as err_rm:
                print('  unable to remove older files : {}'.format(err_rm))
                pass
        # stack_file = next((y for y in arguments if '-p' in y), -1)
        stack_file_name = ('{}/{}'.format(self.proproot, properties[0]))
        message = key = 'new'
        try:
            with open('{}'.format(stack_file_name), 'r') as f:
                stack_name = [f.readline().split('=')[1].rstrip('\n')]
                print stack_name, self.values
                if 'new' not in stackkey:
                    (message, key) = self.get(stack_name)
                else:
                    print('New Stack for {}'.format(stack_name))
        except Exception as error:
            print('Attempt to get stack from {} failed...{}'
                  .format(stack_file_name, error))
        cmd = " ".join(self.arglist)
        if (key not in stackkey[0] or key != 'new'):
            pattern = re.compile('(-s).* ')
            new = re.sub(pattern,
                         '\1 {} '.format(str(key)),
                         '-s {}'.format(stackkey[0]),
                         count=1)
            print("\tWarning: your {} key does not match running {}\n"
                  "\t Try using  '{}'\n".format(stackkey[0], key, new))
        else:
            print(' Key Stack New or Missing')
        print('Executing {} ...'.format(cmd))
        p = subprocess.call(cmd, shell=True)
        print p


def Parseargs():
    """
    parse da args.

    return: argument object.
    testing action overloading in argparse
    """
    parser = argparse.ArgumentParser(description='List Stack Info')
    parser.add_argument('--stackname', '-n',
                        action=call,
                        metavar='stackname',
                        nargs=1,
                        help='the name of the stack to list, defaults to all')
    parser.add_argument('--verbose',
                        dest='verbose',
                        default=False,
                        action='store_true',
                        help='verbose printing')
    parser.add_argument('--stack',
                        '-g',
                        dest='stackit',
                        action='store_true',
                        default=False,
                        help='run stacker with single quoted string w/args')
    parser.add_argument('-p',
                        dest='stackit_prop',
                        nargs=1,
                        default=None,
                        help='Stacker Properties files')
    parser.add_argument('-s',
                        dest='stackit_key',
                        nargs=1,
                        default=None,
                        help='Stacker Stack Secret Key')
    parser.add_argument('-t',
                        dest='stackit_test',
                        action='store_true',
                        default=False,
                        help='Run stacker in test mode')
    parser.add_argument('-l',
                        dest='listem',
                        action='store_true',
                        default=False,
                        help='List possible properties files')
    parser.add_argument('-d',
                        dest='stackit_del',
                        action='store_true',
                        default=False,
                        help='Remove da stack')
    args = parser.parse_args()
    return(args)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('default behavior to list all....')
        do().get('all')
        sys.exit(0)
    MYOPTS = Parseargs()
    if MYOPTS.stackname:
        do().get(MYOPTS.stackname)
        sys.exit(0)

    if MYOPTS.listem:
        do().availableStacks()
    if MYOPTS.stackit:
        do().stackit(MYOPTS.stackit_prop,
                     MYOPTS.stackit_key,
                     MYOPTS.stackit_test,
                     MYOPTS.stackit_del)
    if MYOPTS.stackit_test:
        do().show_diff()
