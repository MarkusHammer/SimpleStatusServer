# Git Auto Backup

[![Python versions](https://img.shields.io/pypi/pyversions/simplestatusserver.svg)](https://pypi.python.org/pypi/simplestatusserver/) [![PyPI](https://img.shields.io/pypi/v/simplestatusserver.svg)](https://pypi.python.org/pypi/simplestatusserver/) [![Downloads](https://pepy.tech/badge/simplestatusserver)](https://pepy.tech/project/simplestatusserver) [![Downloads per week](https://pepy.tech/badge/simplestatusserver/week)](https://pepy.tech/project/simplestatusserver) [![GitHub stars](https://img.shields.io/github/stars/MarkusHammer/SimpleStatusServer.svg)](https://github.com/MarkusHammer/SimpleStatusServer/stargazers)

[![CodeQL](https://github.com/MarkusHammer/SimpleStatusServer/actions/workflows/github-code-scanning/codeql/badge.svg?branch=main)](https://github.com/MarkusHammer/SimpleStatusServer/actions/workflows/github-code-scanning/codeql) [![Dependabot Updates](https://github.com/MarkusHammer/SimpleStatusServer/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/MarkusHammer/SimpleStatusServer/actions/workflows/dependabot/dependabot-updates)

This module is intended to be imported into any script requiring a simple HTTP status reporting page.
This optionally supports threading as well, defining the ``run_threaded`` and ``make_thread`` methods.

## Setup

This module can be installed using:

``pip install simplestatusserver``

## Module Interface

This module only contains a single (fully documented) class: ``SimpleStatusServer``.
This cass can be instantiated to generate and when desired, run, a simple HTTP server.
This server will report the data contained within that instance's ``status`` attribute as json.
The instance itself may also be used as a dictionary, passing along all the data contained withing its ``status``
If the ``threading`` module is imported (which can be checked using the module's ``STATUS_SERVER_THREADING_POSSIBLE`` constant), threading related running methods are also defined for this class.
Refer to the docstrings for each method for more information.
This module contains type hints.

### Example

```python:
from simplestatusserver import SimpleStatusServer, STATUS_SERVER_THREADING_POSSIBLE as THREADING_POSSIBLE
#Note: this example presumes that the threading module is available!
assert THREADING_POSSIBLE, "The threading module must be available for this example to work!"

#some code here...

server = SimpleStatusServer(init_status = {"hello": "world"})
server["world"] == "hello" #returns True
server["status"] = "starting..."
#now run the http server
server.run_threaded(debug = True)

#perhaps a startup routine here?

server["status"] = "running"
del server["world"] #lets remove this key...

try:
  #the main part of a script here...
  pass
except Exception as e:
  server["error"] = str(e)
  server["error code"] = 1

#finish off things here...

print("all done!")

```

## Licence

This is licensed under the Mozilla Public License 2.0 (MPL 2.0) Licence. See the ``Licence`` file in this repository for more information.

## Credits

This project uses the `flask` python module, and may also make use of the `typing-extentions` module for older python versions.

While not required, feel free to credit "*Markus Hammer*" (or just "*Markus*") if you find this code or script useful for whatever you may be doing with it.

**Thanks!**

> Like what you see? Enough to buy me a [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/markushammer) ?
