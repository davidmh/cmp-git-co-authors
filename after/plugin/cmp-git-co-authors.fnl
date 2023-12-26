(local cmp (require :cmp))
(local source (require :cmp-git-co-authors.source))

(cmp.register_source :git-co-authors source)
