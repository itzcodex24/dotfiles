---
description: Review a PR 
---

Firstly, analyse and review the PR using the @code-critic
Secondly, take the output of that review, and generate some human like comments around each suggested change:
  - e.g. i think we should get rid of this log.. just adds too much 
  - e.g. aren't we best to just split this logic out into its own file?

Ensure that these comments are no longer than about 2 sentences to ensure they are nice and concise. They must look human like in the sense that we don't need to use perfect grammar and punctuation

Lastly, generate a list which includes these comments as well as the file name and the line number where this comment should go. Make sure you double check 
this to ensure that, that part of the file, is the correct part to add said comment.
