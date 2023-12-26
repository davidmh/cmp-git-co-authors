# cmp-git-co-authors

Git author completion source for [nvim-cmp] to write `Co-author-by` credits in commit messages.

## Setup

```lua
require('cmp').setup {
  sources = {
    { name = 'git-co-authors' }
  }
}
```

## Options

```lua
require('cmp').setup {
  sources = {
    {
      name = 'git-co-authors',
      option = {
        domain_ranking = {
            ['my-domain.com'] = 1,
            ['users.noreply.github.com'] = 2
        }
      }
    }
  }
}
```

All keys are optional

| option key     | default value                        | description                                                                                                           |
| ---            | ---                                  | ---                                                                                                                   |
| domain_ranking | `{['users.noreply.github.com'] = 1}` | A lookup table to decide which email to pick, if an author has commited with multiple emails. Smaller takes priority. |
| since_date     | `'6 months'`                         | A range limit to use while looking for git authors through the log.                                                   |

[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[lazy.nvim]: https://github.com/folke/lazy.nvim

