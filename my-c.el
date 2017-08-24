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
