(require 'cc-mode)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-hook 'c-mode-hook (lambda () (setq comment-start "// " comment-end   "")))
(add-hook 'c++-mode-hook (lambda () (setq comment-start "// " comment-end   "")))

(defun my-c-mode-insert-lcurly () ; autocomplete ;
  (interactive)
  (insert "{")
  (let ((pps (syntax-ppss)))
    (when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
      (c-indent-line)
      (insert "\n\n}")
      (c-indent-line)
      (forward-line -1)
      (c-indent-line))))

(add-hook 'c-mode-common-hook (lambda () (local-set-key "{" 'my-c-mode-insert-lcurly)))

;; navigation
(require 'subr-x) ;; string functions

(defun c-file-prefix ()
  "Get the standard file prefix from either the header, source, or test file."
  (string-remove-suffix
   "_test"
   (file-name-sans-extension buffer-file-name)))

(defun goto-c-file (suffix)
  (find-file (concat (c-file-prefix) suffix)))

(defun goto-c-source ()
  (interactive)
  (goto-c-file ".cc"))

(defun goto-c-header ()
  (interactive)
  (goto-c-file ".h"))

(defun goto-c-test ()
  (interactive)
  (goto-c-file "_test.cc"))

(bind-key "M-g h" 'goto-c-header c-mode-map)
(bind-key "M-g s" 'goto-c-source c-mode-map)
(bind-key "M-g t" 'goto-c-test c-mode-map)
