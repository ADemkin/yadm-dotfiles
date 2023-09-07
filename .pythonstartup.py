
try:
    import gnureadline as readline
except ImportError:
    # print("could not import gnureadline")
    try:
        import readline
    except ImportError:
        # print("could not import readline")
        pass
    pass

try:
    import rlcompleter
except ImportError:
    # print("could not import rlcompleter")
    pass

autocompletion = globals()
autocompletion.update(locals())
completer = rlcompleter.Completer(autocompletion)
readline.parse_and_bind("tab: complete")
readline.set_completer(completer.complete)

from pprint import pprint as pp
from datetime import datetime
from datetime import timedelta 
from pathlib import Path
import typing
