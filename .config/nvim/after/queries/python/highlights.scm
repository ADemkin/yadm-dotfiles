; extends
((decorator
  "@" @punctuation.special)
  (#set! priority 102))

((class_definition
  name: (identifier) @type.definition)
  (#set! priority 102))
