;;; flycheck-setup --- Summary

;;; Commentary:
;;    Configure the various modes I want to check

;;; Code:

(require 'flycheck)

;; Global config settings
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-display-errors-delay .1)

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

(provide 'flycheck-setup)
;;; flycheck-setup.el ends here
