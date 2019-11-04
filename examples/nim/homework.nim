# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/homework.struct.wings

import json
import times

# Homework - Work to be done at home
type
    Homework* = object
        ID* : int
        name* : string
        dueDate* : DateTime
        givenDate* : DateTime

proc parse*(homework: var Homework, data: string): void =
    let jsonOutput = parseJson(data)
    
    homework.ID = jsonOutput["id"].getInt()
    homework.name = jsonOutput["name"].getStr()
    homework.dueDate = now()
    homework.givenDate = now()