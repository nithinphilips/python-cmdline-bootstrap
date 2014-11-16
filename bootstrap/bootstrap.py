# -*- coding: utf-8 -*-
# PYTHON_ARGCOMPLETE_OK

"""bootstrap.bootstrap: provides entry point main()."""


__version__ = "0.1.0"

import argcomplete
import argparse
import logging
import sys
import configargparse
import argh

from argh import arg

from .stuff import Stuff

# These arguments are used by this global dispatcher and each individual
# stand-alone commands.
COMMON_PARSER = configargparse.ArgParser(add_help=False)
COMMON_PARSER.add_argument('--debug',
                           action='store_true',
                           default=False,
                           env_var="BOOTSTRAP_DEBUG",
                           help="Enable debug logging.")

def main():
    parser = configargparse.ArgParser(
        parents=[COMMON_PARSER], 
        default_config_files=['/etc/bootstrap.conf', '~/.bootstrap']
    )

    argh.assembling.set_default_command(parser, ting)
    argh.completion.autocomplete(parser)

    # Parse ahead
    args = parser.parse_args()
    if args.debug:
        logging.basicConfig(
            level=logging.DEBUG,
            format='%(asctime)s %(levelname)s: %(message)s'
        )

    argh.dispatching.dispatch(parser)

# adding help to `foo` which is in the function signature:
@arg('foo', help='blah')
# these are not in the signature so they go to **kwargs:
@arg('--bar', help='bar')
# the function itself:
def ting(foo, bar=None):
    logging.info("You turned on --debug")
    yield foo
    yield bar

class Boo(Stuff):
    pass
