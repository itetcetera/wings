/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: examples/student.struct
 */

package classroom

import (    
    homework "path/to/homework"
    emotion "github.com/binhonglee/wings/examples/go"
    "time"
)

// Any person who is studying in a class
type Student struct {
    ID int `json:"id"`
    Name string `json:"name"`
    CurClass string `json:"cur_class"`
    IsActive bool `json:"is_active"`
    Year time.Time `json:"year"`
    Homeworks []homework.Homework `json:"homeworks"`
    Something map[string]string `json:"something"`
}

type Students []Student