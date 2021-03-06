;;; Auto-complete-setup --- Summary
;;; Commentary:
;;; Code:

;;; Load yasnippet first to avoid precedence issues
(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(setq ac-auto-start nil)
(setq ac-quick-help-delay 0.5)
(ac-set-trigger-key "TAB")
(define-key ac-mode-map  [(control tab)] 'auto-complete)
(setq-default ac-sources '(ac-source-yasnippet
                           ac-source-abbrev
                           ac-source-dictionary
                           ac-source-words-in-same-mode-buffers))
(add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
(add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
(add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
(add-hook 'css-mode-hook 'ac-css-mode-setup)
(add-hook 'auto-complete-mode-hook 'ac-common-setup)
(global-auto-complete-mode t)
;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (setq ac-sources (append '(ac-source-clang
;;                                        ac-source-yasnippet)
;;                                      ac-sources))))
;; ac-source-gtags

;;; set the trigger key so that it can work together with yasnippet on
;;; tab key, if the word exists in yasnippet, pressing tab will cause
;;; yasnippet to activate, otherwise, auto-complete will
;; (ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")

(provide 'auto-complete-setup)
;;; auto-complete-setup.el ends here
