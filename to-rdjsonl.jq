. as $item |
if .type == "typo" then
  {
    "message": ("`" + .typo + "` should be `" + (.corrections | join("`, `")) + "`"),
    "location": {
      "path": .path,
      "range": {
        "start": { "line": .line_num, "column": (.byte_offset + 1) },
        "end": { "line": .line_num, "column": (.byte_offset + (.typo | length) + 1) }
      }
    },
    "suggestions": .corrections | map({
      "text": .,
      "range": {
        "start": { "line": $item.line_num, "column": ($item.byte_offset + 1) },
        "end": { "line": $item.line_num, "column": ($item.byte_offset + ($item.typo | length) + 1)  }
      }
    })
  }
else
  empty
end
