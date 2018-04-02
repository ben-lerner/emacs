;; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/emacs/packages/themes/")

(use-package color-theme)

(when (display-graphic-p)
  (load-theme 'challenger-deep t)
  ;(load-theme 'nimbus t)
  ;(load-theme 'deeper-blue t)
  )

;; disable annoyances
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1))

(setq ring-bell-function 'ignore) ; turn off bell
(blink-cursor-mode 0)

(setq mouse-drag-copy-region 1) ; automatically copy selected text

(setq backup-inhibited t) ; turn off backups
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; (use-package mode-icons)
;; (mode-icons-mode)

;; terminal theme
(use-package load-theme-buffer-local)

(defun starts-with (needle haystack)
  ;; returns 0 if true (which is truthy)
  ;; nil (false) if false
  (string-match
   (concat "^" needle)
   haystack))

(telephone-line-defsegment* telephone-line-short-vc-segment ()
  (telephone-line-raw
   (cond ((not vc-mode) nil)
         ((starts-with "Git" vc-mode))
         (t vc-mode))))

;; nice modal line
(use-package telephone-line)
(setq telephone-line-primary-left-separator 'telephone-line-gradient
      telephone-line-secondary-left-separator 'telephone-line-nil
      telephone-line-primary-right-separator 'telephone-line-gradient
      telephone-line-secondary-right-separator 'telephone-line-nil)
(setq telephone-line-height 24
      telephone-line-evil-use-short-tag t)
(setq telephone-line-lhs
      '((accent . (telephone-line-short-vc-segment))
        (nil    . (telephone-line-buffer-segment))))

(setq telephone-line-rhs
      '((nil    . (telephone-line-misc-info-segment
                   telephone-line-major-mode-segment))
        (accent . (telephone-line-airline-position-segment))))

(telephone-line-mode 1)

;; pretty lambda
;; misc
(fringe-mode '(4 . 6))
(setq show-paren-delay 0)
(show-paren-mode t)
(setq-default cursor-in-non-selected-windows nil)
;; setq-default sets this value in *every* buffer

; XML pretty print
(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      ;(nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end)))


(add-hook 'nxml-mode-hook (lambda () (bf-pretty-print-xml-region (point-min) (point-max))))

; enable colors. need 'export TERM=xterm-256color' in bash profile.
;; (use-package xterm-color)
;; (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter)
;; (setq comint-output-filter-functions
;;       (remove 'ansi-color-process-output comint-output-filter-functions))
;; (setq font-lock-unfontify-region-function 'xterm-color-unfontify-region)

;; fix line number margin issue when font increases
(use-package linum)
(defun linum-update-window-scale-fix (win)
  "fix linum for scaled text"
  (set-window-margins win
          (ceiling (* (if (boundp 'text-scale-mode-step)
                  (expt text-scale-mode-step
                    text-scale-mode-amount) 1)
              (if (car (window-margins))
                  (car (window-margins)) 1)
              ))))
(advice-add #'linum-update-window :after #'linum-update-window-scale-fix)

(use-package rainbow-delimiters)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(term-default-fg-color "#00e2ff"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-2-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "steel blue"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "purple"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "violet red"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "firebrick")))))
