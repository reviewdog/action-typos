. as $item |
if .type == "typo" then
  {
    "message": ("Typo: " + .typo + " -> " + (.corrections | join(", "))),
    "location": {
      "path": .path,
      "range": {
        "start": { "line": .line_num, "column": .byte_offset },
        "end": { "line": .line_num, "column": (.byte_offset + (.typo | length)) }
      }
    },
    "suggestions": .corrections | map({
      "text": .,
      "range": {
        "start": { "line": $item.line_num, "column": $item.byte_offset },
        "end": { "line": $item.line_num, "column": ($item.byte_offset + ($item.typo | length))  }
      }
    })
  }
else
  empty
end
