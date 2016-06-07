;;; Init.el --- Summary

;;; Commentary:
;;  My standard Emacs init config

;;; Code:

;; This is needed so I can use the current buffer for testing
(setq lexical-binding t)


(require 'cask "/opt/cask/cask.el")
(cask-initialize)

;; Standard configs
(setq
   backup-by-copying t
   backup-directory-alist '(("." . "~/.emacs_saves"))
   delete-old-versions t
   version-control nil
)

(set-face-attribute 'default nil :height 100)

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
(tool-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;       Load module configs


;; Set up load path
(add-to-list 'load-path (expand-file-name "configs" user-emacs-directory))


;;; (depends-on "auto-complete")
(require 'auto-complete-setup)


;;; (depends-on "dired-details+")
; Fancier dired display
(require 'dired-details+)
(setq
   dired-details-hidden-string ""
   dired-use-ls-dired nil
)

;;; (depends-on "fill-column-indicator")
(require 'fill-column-indicator)
(add-hook 'after-change-major-mode-hook
  (lambda ()
    ;; (message "Running Change Mode Hook for buffer %s %s" buffer-file-name (length buffer-file-name))
    (when (> (length buffer-file-name) 0)
      ;; Turn on fci-mode iff the file is not a jsx
      (if (string-match "\\.jsx$" buffer-file-name) (turn-off-fci-mode) (turn-on-fci-mode))

      ;; Change the fci column to 120 if is python, 80 if not
      (make-local-variable 'fci-rule-column)
      (if (string-match "\\.py$" buffer-file-name) (setq fci-rule-column 80) (setq fci-rule-column 120))
    )
  )
)



;;; (depends-on "flycheck")
(require 'flycheck-setup)

;;; (depends-on "flycheck-rust")
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;;; (depends-on "jedi")
(require 'jedi)
(setq
   jedi:complete-on-dot t
   jedi:setup-keys t
)


;;; (depends-on "js2-mode")
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js2-basic-offset 2)


;;; (depends-on "json-mode")
(require 'js2-mode)
(setq
   json-reformat:indent-width 2
   js-indent-level 2
)


;;; (depends-on "pallet")
(require 'pallet)
(pallet-mode t)


;;; (depends-on "scss-mode")
(require 'scss-mode)
(setq css-indent-offset 2)


;;; (depends-on "web-mode")
(defun my-web-mode-hook ()
  "Hooks for Web mode.

   Set the indents and kill fci-mode since there is a bug
   https://github.com/alpaker/Fill-Column-Indicator/issues/46"

  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(add-hook 'web-mode-hook  'my-web-mode-hook)

;; Handle JSX files from:
;; https://truongtx.me/2014/03/10/emacs-setup-jsx-mode-and-jsx-syntax-checking/
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  "Display the error message/highlight the error."
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        ad-do-it)
    ad-do-it))

(add-hook 'jsx-mode-hook (lambda () (auto-complete-mode 1)))



(defun string/ends-with (s ending)
  "Return non-nil if string S ends with ENDING."
  (cond ((>= (length s) (length ending))
         (let ((elength (length ending)))
           (string= (substring s (- 0 elength)) ending)))
        (t nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;       Finalize the window layout


;; Resize the window
(if window-system
    (progn
        (setq default-frame-alist '(
            (width . 250)
            (height . 100)
            (menu-bar-lines . 1)))
        (message "In Window System")
        (delete-other-windows)
        (split-window-horizontally)))


;; If the font size is too small, eval (M-:) this statement
;; (set-face-attribute 'default nil :height 150)

(provide 'init)
;;; init.el ends here
