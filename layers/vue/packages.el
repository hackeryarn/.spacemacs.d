(setq vue-packages
      '(vue-mode))

(setq vue-excluded-packages '())

(defun vue/init-vue-mode ()
  (use-package vue-mode
    :config
    ;; 0, 1, or 2, representing (respectively) none, low, and high coloring
    (setq mmm-submode-decoration-level 0)))
