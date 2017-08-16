;; python autocomplete
(global-set-key (kbd "C-c m")
				(lambda ()
				  (interactive)
				  (insert "if __name__ == '__main__':
    ")))


;; python debugger
(add-hook 'python-mode-hook
		  (lambda () (highlight-lines-matching-regexp "^[ ]*import i?pdb; i?pdb.set_trace()")))

  
(defun add-breakpoint (text)
  "Add a break point"
  (newline-and-indent)
  (insert text)
  (highlight-lines-matching-regexp "^[ ]*import i?pdb; i?pdb.set_trace()"))

(defun ipython-add-breakpoint ()
  (interactive)
  (add-breakpoint "import ipdb; ipdb.set_trace()"))

(defun python-add-breakpoint ()
  (interactive)
  (add-breakpoint "import pdb; pdb.set_trace()"))

(defun ipdb-run-string (filepath)
  ;; returns text to run ipdb
  ;; proceeds to first breakpoint instead of starting at the top of the file
  (concat "ipdb " filepath) ;; basic ipdb
  ;(concat "ipython --pdb --c=\"%run " filepath "\";")
  )

;; todo: add variant that prompts for args

(defun ipdb-debug ()
  ;; run current file in ipdb
  (interactive)
  (ipdb (ipdb-run-string (buffer-file-name)))
  ;; run until first breakpoint or exception
  (sleep-for 0.5) ;; this should probably be a hook
  (insert "c")
  (realgud:send-input) )


(eval-after-load "python-mode"
  '(begin
    (bind-key "C-c C-c" 'ipdb-debug python-mode-map)
    (bind-key "C-c C-b" 'ipython-add-breakpoint python-mode-map)
    (bind-key "C-c C-i C-b" 'python-add-breakpoint python-mode-map)
    (bind-key "C-." 'elpy-goto-definition python-mode-map)
    (bind-key "C-," 'xref-pop-marker-stack python-mode-map)))

;; elpy mode
;; run: pip install jedi flake8 importmagic autopep8
(unless (package-installed-p 'elpy)
  (require 'package)
  (add-to-list 'package-archives
               '("elpy" . "https://jorgenschaefer.github.io/packages/"))
  (package-refresh-contents)
  (package-install 'elpy))

(package-initialize)
(elpy-enable)
(add-hook 'python-mode-hook (lambda ()
                              (begin
                               (highlight-indentation-mode 0)
                               (flymake-mode 0))))
