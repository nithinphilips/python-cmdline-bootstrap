import re

version = re.search(
    '^__version__\s*=\s*"(.*)"',
    open('bootstrap/bootstrap.py').read(),
    re.M
    ).group(1)

print("{}".format(version))
