(when (configuration-layer/package-used-p 'org)
  (defun org-config/open-inbox ()
    "Opens my gtd inbox file"
    (interactive)
    (find-file "~/Dropbox/gtd/inbox.org"))

  (defun org-config/open-journal ()
    "Opens my journal file"
    (interactive)
    (find-file "~/Dropbox/org/journal.org"))

  (defun org-config/open-task-journal ()
    "Opens my journal file"
    (interactive)
    (find-file "~/Dropbox/org/task-journal.org")))

(defun org-config/get-day (post)
  "Gets the day number from the post"
  (string-match "\\([[:digit:]]+\\)" post)
  (string-to-number (match-string 1 post)))

(defun org-config/next-post-name (post)
  "Creates the title for the next post with the previous post"
 (format "day%d.md"(+ 1 (org-config/get-day post))))

(defun org-config/increment-day ()
  (let (p1 p2 word)
    (search-forward "day: ")
    (setq p1 (point))
    (forward-word)
    (setq p2 (point))
    (setq word (buffer-substring-no-properties p1 p2))
    (backward-word)
    (kill-word 1)
    (insert (number-to-string (+ 1 (string-to-number word))))))

(defun org-config/update-date ()
  (search-forward "date: ")
  (kill-line)
  (insert (format-time-string "%Y-%m-%d")))

(defun org-config/update-metadata (post)
  (with-temp-buffer
    (insert-file-contents post)
    (let (p1 p2)
      (setq p1 (point))
      (search-forward "---")
      (org-config/increment-day)
      (org-config/update-date)
      (search-forward "---")
      (setq p2 (point))
      (buffer-substring-no-properties p1 p2))))

(defun org-config/new-post ()
  "Creates a new post for daily reading notes"
  (interactive)
  (let* ((old-post-name (buffer-name (current-buffer)))
         (new-post-name (org-config/next-post-name old-post-name))
         (metadata (org-config/update-metadata old-post-name)))
    (with-temp-file new-post-name
      (insert metadata))
    (find-file new-post-name)
    (kill-buffer old-post-name)))
