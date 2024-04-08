(local default-config (require :cmp-git-co-authors.default-config))

(local source {})

(fn source.is_available []
  (= vim.o.ft :gitcommit))

(fn source.get_debug_name []
  :git-co-authors)

(fn source.get_keyword_pattern []
  "Co-authored-by")

(fn source.get_trigger_characters []
  [":"])

(fn make-compare-email-domain-fn [domain-ranking-table]
  (fn compare-domain-rank [author-line]
    (or
      (. domain-ranking-table (string.match author-line "<.*@(.*)>"))
      math.huge))

  (fn [a b]
    (< (compare-domain-rank a) (compare-domain-rank b))))

(fn source.complete [self params callback]
  (local options (vim.tbl_extend "force" default-config (or params.option {})))
  (local compare-email-domain (make-compare-email-domain-fn options.domain_ranking))

  (local entries (-> [:git :shortlog :-nes (.. "--since='" options.since_date "'") :HEAD]
                    (vim.system {:text true})
                    (: :wait)
                    (. :stdout)
                    (vim.trim)
                    (vim.split "\n")))

  (table.sort entries compare-email-domain)
  (local emails-by-author-name {})

  ;; collect all the emails by author name
  (each [_ line (ipairs entries)]
    (local (name email) (string.match line "^.*%d*\t(.*) <(.*)>$"))
    (local emails (or (. emails-by-author-name name) []))
    (table.insert emails email)
    (tset emails-by-author-name name emails))

  ;; turn the dictionary of emails by author name into a list of items
  (local items [])
  (each [name emails (pairs emails-by-author-name)]
    (local insert-text (.. name " <" (. emails 1) ">"))
    (table.insert items {:label (.. "Co-authored-by: " insert-text)
                         :insertText insert-text
                         :filterText (.. name " " (table.concat emails " "))}))

  (callback {:items items}))

source
