-- [nfnl] Compiled from fnl/cmp-git-co-authors/source.fnl by https://github.com/Olical/nfnl, do not edit.
local default_config = require("cmp-git-co-authors.default-config")
local source = {}
source.is_available = function()
  return (vim.o.ft == "gitcommit")
end
source.get_debug_name = function()
  return "git-co-authors"
end
source.get_keyword_pattern = function()
  return "Co-authored-by:"
end
source.get_trigger_characters = function()
  return {":"}
end
local function make_compare_email_domain_fn(domain_ranking_table)
  local function compare_domain_rank(author_line)
    return (domain_ranking_table[string.match(author_line, "<.*@(.*)>")] or math.huge)
  end
  local function _1_(a, b)
    return (compare_domain_rank(a) < compare_domain_rank(b))
  end
  return _1_
end
source.complete = function(self, params, callback)
  local options = vim.tbl_extend("force", default_config, (params.option or {}))
  local compare_email_domain = make_compare_email_domain_fn(options.domain_ranking)
  local entries = vim.split(vim.trim((vim.system({"git", "shortlog", "-nes", ("--since='" .. options.since_date .. "'"), "HEAD"}, {text = true}):wait()).stdout), "\n")
  table.sort(entries, compare_email_domain)
  local emails_by_author_name = {}
  for _, line in ipairs(entries) do
    local name, email = string.match(line, "^.*%d*\9(.*) <(.*)>$")
    local emails = (emails_by_author_name[name] or {})
    table.insert(emails, email)
    do end (emails_by_author_name)[name] = emails
  end
  local items = {}
  for name, emails in pairs(emails_by_author_name) do
    local label = (name .. " <" .. emails[1] .. ">")
    table.insert(items, {label = label, insertText = label, filterText = (name .. " " .. table.concat(emails, " "))})
  end
  return callback({items = items})
end
return source
