#!/bin/sh

set -e -u
jq -Rr '
    . as $input |
    try fromjson catch {"raw":$input} |
    to_entries |
    ["---"]+
    [ .[] |
        if (.value | tostring | test("\n")) then
            "  \(.key): |\n" +
            (.value|split("\n")|map("    "+.)|join("\n"))
        else
            "  \(.key): \(.value)"
        end
    ] | join("\n")
'


