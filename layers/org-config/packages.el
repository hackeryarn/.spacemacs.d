(defconst org-config-packages
  '((org)
    (org-brain)))

(defun org-config/post-init-org ()
  ;; Refile
  (advice-add 'org-agenda-quit :before 'org-save-all-org-buffers)
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-targets '(("~/Dropbox/gtd/todo.org" :level . 1)
                             ("~/Dropbox/gtd/work.org" :level . 1)))

  ;; active Org-babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(;; other Babel languages
     (plantuml . t)))

  (setq org-plantuml-jar-path
        (expand-file-name "~/.doom.d/scripts/plantuml.jar"))

  (setq my-gtd-tags
        '(("computer")
          ("digital")
          ("home")
          ("out")
          ("watch")
          ("book")
          ("work")))

  (defun create-org-tag-alist (tags)
    (append '((:startgrouptag)
              ("GTD")
              (:grouptags))
            tags
            '((:endgrouptag))))

  (setq org-tag-alist (create-org-tag-alist my-gtd-tags))

  ;; Agenda Custom Command

  (setq org-agenda-start-day "-1d")

  (defun create-org-agenda-skip-entry-if (tag)
    `'(org-agenda-skip-entry-if
       'notregexp ,(concat ":" (car tag) ":")))

  (defun create-task-agenda-custom-command (tag)
    (list 'todo
          "TODO"
          (list
           (list
            'org-agenda-skip-function
            (create-org-agenda-skip-entry-if tag))
           (list
            'org-agenda-overriding-header
            (capitalize (car tag))))))

  (defun create-home-agenda-custom-command (span)
    (list
     (list 'agenda ""
           (list
            (list 'org-agenda-span span)
            '(org-agenda-files '("~/Dropbox/gtd/todo.org"))))))

  (defun create-home-task-list ()
    '((todo "TODO"
            ((org-agenda-overriding-header "Todo")
             (org-agenda-todo-ignore-deadlines 'all)
             (org-agenda-todo-ignore-scheduled 'all)
             (org-agenda-files '("~/Dropbox/gtd/todo.org"))))
      (todo "WAITING"
            ((org-agenda-overriding-header "Waiting")
             (org-agenda-todo-ignore-deadlines 'all)
             (org-agenda-todo-ignore-scheduled 'all)
             (org-agenda-files '("~/Dropbox/gtd/todo.org"))))))

  (defun create-work-agenda-custom-command (span)
    (list
     (list 'agenda ""
           (list
            (list 'org-agenda-span span)
            '(org-agenda-files '("~/Dropbox/gtd/work.org"))))))

  (defun create-work-task-list ()
    '((todo "TODO"
            ((org-agenda-overriding-header "Todo")
             (org-agenda-todo-ignore-deadlines 'all)
             (org-agenda-todo-ignore-scheduled 'all)
             (org-agenda-files '("~/Dropbox/gtd/work.org"))))
      (todo "WAITING"
            ((org-agenda-overriding-header "Waiting")
             (org-agenda-todo-ignore-deadlines 'all)
             (org-agenda-todo-ignore-scheduled 'all)
             (org-agenda-files '("~/Dropbox/gtd/work.org"))))))

  (defun create-daily-home-agenda-custom-command ()
    (list "dh" "Home" (append (create-home-agenda-custom-command 3)
                              (create-home-task-list))))
  (defun create-daily-work-agenda-custom-command ()
    (list "dw" "Work" (append (create-work-agenda-custom-command 3)
                              (create-work-task-list))))
  (defun create-weekly-home-agenda-custom-command ()
    (list "wh" "Home" (append (create-home-agenda-custom-command 8)
                              (create-home-task-list))))
  (defun create-weekly-work-agenda-custom-command ()
    (list "ww" "Work" (append (create-work-agenda-custom-command 8)
                              (create-work-task-list))))

  (defun create-org-agenda-custom-commands ()
    (list (create-daily-home-agenda-custom-command)
          (create-daily-work-agenda-custom-command)
          (create-weekly-home-agenda-custom-command)
          (create-weekly-work-agenda-custom-command)))

  ;; Agenda
  (setq org-agenda-prefix-format " %b")
  (setq org-agenda-files '("~/Dropbox/gtd/todo.org"))
  (setq org-agenda-custom-commands (create-org-agenda-custom-commands))

  ;; Capture
  (setq-default org-todo-keywords '((sequence "TODO(t)" "SCHEDULED(s)" "WAITING(w)" "TALK(z)" "|" "DONE(d)" "CANCELLED(c)")
                                    (sequence "PROJECT(p)" "MAYBE(m)")))

  (defun create-tag-capture (tag)
    (let ((tag (car tag)))
      (list tag (capitalize tag) 'entry
            '(file "~/Dropbox/gtd/todo.org")
            (concat "* TODO %i%? :" tag ":"))))

  (defun org-template-project ()
    '("p" "Project" entry
      (file "~/Dropbox/gtd/todo.org")
      "* PROJECT %i%? [%]"))

  (defun org-template-talk ()
    '("z" "Talk" entry
      (file "~/Dropbox/gtd/todo.org")
      "* TALK %i%? :%^{who}:"))

  (defun org-template-todo ()
    '("i" "Inbox" entry
      (file "~/Dropbox/gtd/inbox.org")
      "* TODO %i%?"))

  (defun org-template-tickler ()
    '("T" "Tickler" entry
      (file "~/Dropbox/gtd/todo.org")
      "* SCHEDULED %i%? \n DEADLINE:%^{Deadline}t"))

  (defun org-template-journal ()
    '("j" "Journal" entry
      (file+olp+datetree "~/org/journal.org")
      "* %?" :tree-type week))

  (setq org-capture-templates (append
                               (mapcar #'create-tag-capture my-gtd-tags)
                               (list (org-template-todo)
                                     (org-template-journal)
                                     (org-template-talk)
                                     (org-template-project)
                                     (org-template-tickler)))))

(defun org-config/pre-init-org-brain ()
  (setq org-brain-path "~/Dropbox/brain"))
