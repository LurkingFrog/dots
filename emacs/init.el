(require 'cask "/opt/cask/cask.el")
(cask-initialize)

;; Standard configs
(setq
   backup-by-copying t
   backup-directory-alist '(("." . "~/.emacs_saves"))
   delete-old-versions t
   version-control nil
)

; show the current line and column numbers in the stats bar as well
(line-number-mode t)
(column-number-mode t)

; turn on mouse wheel support for scrolling
(require 'mwheel)
(mouse-wheel-mode t)

; highlight parentheses when the cursor is next to them
(require 'paren)
(show-paren-mode t)

;; Eliminate trailing whitespace every time we save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; I hate tabs!
(setq-default indent-tabs-mode nil)

; don't show the startup screen
(setq inhibit-startup-screen t)

; don't show the tool bar
(require 'tool-bar)
(tool-bar-mode nil)

;; Resize the window
(if window-system
    (progn
        (setq default-frame-alist '(
            (width . 166)
            (height . 50)
            (menu-bar-lines . 1)))
        (message "In Window System")
        (delete-other-windows)
        (split-window-horizontally)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;       Load module configs



;;; (depends-on "auto-complete")
(require 'auto-complete-config)


;;; (depends-on "dired-details+")
; Fancier dired display
(require 'dired-details+)
(setq
   dired-details-hidden-string ""
   dired-use-ls-dired nil
)

;;; (depends-on "fill-column-indicator")
(require 'fill-column-indicator)
(setq fci-rule-column 80)
(add-hook 'after-change-major-mode-hook 'fci-mode)

;;; (depends-on "flycheck")
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-display-errors-delay .1)


;;; (depends-on "js2-mode")
(require 'js2-mode)
(setq js2-basic-offset 2)


;;; (depends-on "jedi")
(require 'jedi)
(setq
   jedi:complete-on-dot t
   jedi:setup-keys t
)


;;; (depends-on "pallet")
(require 'pallet)
(pallet-mode t)



(provide 'init)
