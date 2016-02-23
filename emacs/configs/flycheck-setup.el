;;; flycheck-setup --- Summary

;;; Commentary:
;;    Configure the various modes I want to check

;;; Code:

(require 'flycheck)

;; Global config settings
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-display-errors-delay .1)
(setq flycheck-idle-change-delay 5)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
;; run "sudo npm install -g eslint eslint-plugin-react" from the command line
;; the config for this is in ../../node/eslintrc.js
(flycheck-add-mode 'javascript-eslint 'web-mode)

(defun flycheck-reset-and-run ()
  "Reset the disabled checkers and run flycheck.

   Python has an issue with disabling flake8 when flycheck runs while I'm
   typing a command before closing the parens.  This resets flycheck so I can
   see pep8 warnings again"

  (interactive)
  (setq flycheck-disabled-checkers '(javascript-jshint))
  (flycheck-buffer)
)

; Reset disabled flycheck checkers and run the checker
(global-set-key (kbd "C-c f") 'flycheck-reset-and-run)
(global-set-key (kbd "C-;") 'flycheck-next-error)
(global-set-key (kbd "C-:") 'flycheck-previous-error)


(provide 'flycheck-setup)
;;; flycheck-setup.el ends here
