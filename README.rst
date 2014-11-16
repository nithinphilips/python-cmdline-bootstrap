python-cmdline-bootstrap
========================

This is a structure template for Python command line applications, ready to be
released and distributed via setuptools/PyPI/pip for Python 2 and 3.

Please have a look at the corresponding article:
http://gehrcke.de/2014/02/distributing-a-python-command-line-application/


configargparse
--------------
This branch uses the `configargparse
<https://github.com/zorro3/ConfigArgParse>`_ library instead of vanilla
argparse

This allows argument values to be specified using environment variables or
configuration files. configargparse does not currently support reading
configuration values for subparsers.

Environment variable:

The ``--debug`` flag is tied to the ``BOOTSTRAP_DEBUG`` environment variable,
so you can::

    $ BOOTSTRAP_DEBUG=True python bootstrap-runner.py foo
    2014-11-16 00:06:06,959 INFO: You turned on --debug
    foo
    None

Any optional arguments can be specified in a config file as well::

    $ cat ~/.bootstrap
    bar=barsoap

Then you can::

    $python bootstrap-runner.py foo
    foo
    barsoap

The ``barsoap`` value was read from ``~/.bootstrap``.

Usage
-----

Clone this repository and adopt the bootstrap structure for your own project.
This is just a starting point, but I hope a good one. From there on, you should
read and follow http://python-packaging-user-guide.readthedocs.org/en/latest/,
the definite resource on Python packaging.



Behavior
--------

Flexible invocation
*******************

The application can be run right from the source directory, in two different
ways:

1) Treating the bootstrap directory as a package *and* as the main script::

    $ python -m bootstrap arg1 arg2
    Executing bootstrap version 0.2.0.
    List of argument strings: ['arg1', 'arg2']
    Stuff and Boo():
    <class 'bootstrap.stuff.Stuff'>
    <bootstrap.bootstrap.Boo object at 0x7f43d9f65a90>

2) Using the bootstrap-runner.py wrapper::

    $ ./bootstrap-runner.py arg1 arg2
    Executing bootstrap version 0.2.0.
    List of argument strings: ['arg1', 'arg2']
    Stuff and Boo():
    <class 'bootstrap.stuff.Stuff'>
    <bootstrap.bootstrap.Boo object at 0x7f149554ead0>


Installation sets up bootstrap command
**************************************

Situation before installation::

    $ bootstrap
    bash: bootstrap: command not found

Installation right from the source tree (or via pip from PyPI)::

    $ python setup.py install

Now, the ``bootstrap`` command is available::

    $ bootstrap arg1 arg2
    Executing bootstrap version 0.2.0.
    List of argument strings: ['arg1', 'arg2']
    Stuff and Boo():
    <class 'bootstrap.stuff.Stuff'>
    <bootstrap.bootstrap.Boo object at 0x7f366749a190>


On Unix-like systems, the installation places a ``bootstrap`` script into a
centralized ``bin`` directory, which should be in your ``PATH``. On Windows,
``bootstrap.exe`` is placed into a centralized ``Scripts`` directory which
should also be in your ``PATH``.
