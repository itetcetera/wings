const TYPE_PREFIX*: string = "{TYPE"
const TYPE_POSTFIX*: string = "}"

const TK_PREFIX: string = "{#"
const TK_SEPARATOR*: string = "_"
const TK_POSTFIX: string = "}"

const TK_COMMENT*: string = "COMMENT"
const TK_FILENAME*: string = "FILENAME"
const TK_FUNCTIONS*: string = "FUNCTIONS"
const TK_IMPLEMENT*: string = "IMPLEMENT"
const TK_IMPORT*: string = "IMPORT"
const TK_INIT*: string = "INIT"
const TK_JSON*: string = "JSON"
const TK_NAME*: string = "NAME"
const TK_PARSE*: string = "PARSE"
const TK_IPREFIX*: string = "PREFIX"
const TK_SPACED*: string = "SPACED"
const TK_TYPE*: string = "TYPE"
const TK_VARNAME*: string = "VARNAME"

const TYPE_IMPORTED*: string = "!imported"
const TYPE_UNIMPORTED*: string = "!unimported"

proc wrap*(s: string, ss: varargs[string]): string =
  result = TK_PREFIX & s
  for str in ss:
    result &= TK_SEPARATOR & str
  result &= TK_POSTFIX
