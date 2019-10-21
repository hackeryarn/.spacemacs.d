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

(defun org-config/new-post ()
  "Creates a new post for daily reading notes"
  (interactive)
  (let* ((old-buffer-name (buffer-name (current-buffer)))
         (new-file-name (shell-command-to-string
                         (concat "new-post " old-buffer-name))))
    (find-file (string-trim new-file-name))
    (kill-buffer old-buffer-name)
    (goto-char (point-max))))

(defun org-config/get-day (post)
  "Gets the day number from the post"
  (string-match "\\([[:digit:]]+\\)" post)
  (string-to-number (match-string 1 post)))

(defun org-config/next-post-name (post)
  "Creates the title for the next post with the previous post"
 (format "day%d.md"(+ 1 (org-config/get-day post))))
