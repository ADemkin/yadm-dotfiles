import readline
import rlcompleter

completer = rlcompleter.Completer(globals() | locals())
readline.parse_and_bind("tab: complete")
readline.set_completer(completer.complete)
