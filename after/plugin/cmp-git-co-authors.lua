-- [nfnl] Compiled from after/plugin/cmp-git-co-authors.fnl by https://github.com/Olical/nfnl, do not edit.
local cmp = require("cmp")
local source = require("cmp-git-co-authors.source")
return cmp.register_source("git-co-authors", source)
