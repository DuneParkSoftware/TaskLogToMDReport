TaskLogToMDReport
=================

Converts a TaskLog export CSV file into a simple Markdown report.

_This is very early-release software, and may contain unknown bugs._

__Known limitations include:__

- Currently only compatible with TaskLog's Export duration format "00:00:00".
- Report task duration times are rounded, and there is currently no option to use exact durations.
- Report task duration times are hour and minute only, with no option to display seconds.
- The resulting Markdown report format is static; no templating support.

__Usage:__

`> tasklog2md exportFile.csv [-o outputFile.md]`

The resulting file can be opened in a Markdown-compatible viewer or editor, and converted to any other suitable format, such as PDF. The reports can also be archived, shared with collaborators, etc.
