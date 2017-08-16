; run goimports on save
(setq gofmt-command "goimports")

(use-package go-mode-load)
(use-package go-eldoc)
(use-package go-autocomplete)
(use-package auto-complete-config)

(require 'go-guru)

;; go-mode-load must be generated, see "installation" in
;; http://dominik.honnef.co/posts/2013/03/writing_go_in_emacs/

;; packages:
;;; go-dlv

;; panic parse: https://github.com/maruel/panicparse

;;; set paths for godef
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))
(setenv "GOPATH" (expand-file-name "~/go/"))
(setenv "GOROOT" "/usr/local/opt/go/libexec")
;;;

(unbind-key "C-<return>" go-mode-map)
(bind-key "C-." 'godef-jump go-mode-map)
(bind-key "C-," 'pop-tag-mark go-mode-map)
(bind-key "C-c f" (lambda ()
                          (interactive)
                          (insert "fmt.Printf(\"%v\\n\", ")) go-mode-map)
(defun save-and-compile ()
  (interactive)
  (save-buffer)
  (compile compile-command))

(bind-key "C-c C-c" 'save-and-compile go-mode-map)
(bind-key "C-c C-b" 'compile go-mode-map)
(bind-key "C-c C-r" 'go-rename go-mode-map) ;; todo: save buffer first


(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go test -run=."))
  (go-guru-hl-identifier-mode))

(add-hook 'go-mode-hook 'my-go-mode-hook)
(eval-after-load "go-mode" '(require 'flymake-go))

(defun flymake-display-warning (warning) (message warning))
;; display flymake errors in the mini-buffer, not in a pop-up

;; autocomplete

(bind-key "C-c C-e"
          (lambda ()
            (interactive)
            (insert "if err != nil {
                               return , err
                            }")
            
            ;; indent + set point
            (previous-line 2)
            (indent-for-tab-command)
            (next-line)
            (indent-for-tab-command)
            (next-line)
            (indent-for-tab-command)
            (previous-line)
            (move-end-of-line 1)
            (backward-char 5))
          go-mode-map)
