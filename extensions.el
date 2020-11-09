(require 'exec-path-from-shell)
(exec-path-from-shell-initialize) ;; emacs gets bash vars

(require 'ag)

;; spellcheck
;; todo: turn on aspell if it exists
(setq ispell-program-name "aspell")
(setq ispell-silently-savep t)  ;; don't confirm when saving new words
;; installed from aspell.net/win32/ on windows; install aspell and english dict
;  directory defined per local system

;; minibuffer completion
(setq completion-cycle-threshold 4) ; cycle through options if there are <= 4
(setq completion-auto-help 'true) ; otherwise show help
(setq read-buffer-completion-ignore-case 'true) ; ignore case for buffer names

(global-auto-revert-mode t)
(on-mac (setq browse-url-browser-function 'browse-url-default-macosx-browser))
(on-linux (setq browse-url-browser-function 'browse-url-chromium))

;; packages
(when (>= 24 emacs-major-version)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa-stable" . "http://stable.melpa.org/packages/") t)
  (package-refresh-contents)
  )

;; yaml
(use-package yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml.erb\\'" . yaml-mode))
(bind-key "C-m" 'newline-and-indent yaml-mode-map)


;; org mode
(use-package org)
(bind-key* "C-c l" 'org-store-link)
(bind-key* "C-c a" 'org-agenda)
(setq org-log-done t)
(setq org-ellipsis "▼")
(setq auto-save-default nil)

;; tables
(add-hook 'text-mode-hook 'table-recognize)

(add-hook 'text-mode-hook 'goto-address-mode)
(add-hook 'prog-mode-hook 'goto-address-mode)

(bind-key* "C-c C-w" 'goto-address-mode)

;; automake missing dir
;;; todo: extend this to work for more than one missing folder
(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
        (make-directory dir t)))))

;; make intermediate dirs automatically
(add-hook 'before-save-hook
		  (lambda ()
            (when buffer-file-name
              (let ((dir (file-name-directory buffer-file-name)))
                (when (not (file-exists-p dir))
                  (make-directory dir t))))))

;; clipboard <-> kill-ring interop
(setq save-interprogram-paste-before-kill t)
(setq yank-pop-change-selection t)

;; better emacs kill
(defun my-kill-emacs ()
  "save some buffers, then exit unconditionally" ;; avoids process check
  (interactive)
  (save-some-buffers nil t)
  (kill-emacs))

(bind-key* "C-x C-c" 'my-kill-emacs)


; deal with buffers that have the same name
(use-package uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;;; this is slow
;; match shell variables to bash shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


;; ivy
(require 'ivy)
(require 'counsel)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(setq ivy-re-builds-alist
      '((t      . ivy--regex-fuzzy)))

(bind-key* "M-x" 'counsel-M-x)
(bind-key* "C-x C-f" 'counsel-find-file)

;; todo - try these functions and add good ones
;; (bind-key* "C-c C-r" 'ivy-resume)
;; (bind-key* "<f6>" 'ivy-resume)
;; (bind-key* "<f1> f" 'counsel-describe-function)
;; (bind-key* "<f1> v" 'counsel-describe-variable)
;; (bind-key* "<f1> o" 'counsel-describe-symbol)
;; (bind-key* "<f1> l" 'counsel-find-library)
;; (bind-key* "<f2> i" 'counsel-info-lookup-symbol)
;; (bind-key* "<f2> u" 'counsel-unicode-char)
;; (bind-key* "C-c g" 'counsel-git)
;; (bind-key* "C-c j" 'counsel-git-grep)
;; (bind-key* "C-c k" 'counsel-ag)
;; (bind-key* "C-x l" 'counsel-locate)
;; (bind-key* "C-S-o" 'counsel-rhythmbox)

(define-key minibuffer-local-map (kbd  "C-r") 'counsel-minibuffer-history)

(electric-pair-mode)  ;; insert matching parens and type through matches
(global-undo-tree-mode)
