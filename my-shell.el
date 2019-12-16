(use-package multi-term)

(setq multi-term-program "/bin/bash")

;; todo: move all shell code here

;; get shell-command (M-!) to execute bash profile
(setq shell-file-name "bash")

(on-mac
 (setq shell-command-switch "-ic"))

(on-linux
 (defun shell-command-with-profile (cmd)
   (interactive "sShell command: ")
   (shell-command (concat "source ~/.bash_profile && " cmd)))
 (bind-key* "M-!" 'shell-command-with-profile))

(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

(defun term-toggle-mode ()
  "Toggles term between line mode and char mode"
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

(add-hook 'term-mode-hook 'goto-address-mode)

(bind-key* "C-#"
  (lambda () ;; close window + scroll to bottom of terminal. for git editor pop-ups
	(interactive)
    (save-buffer)
	(server-edit)
	(end-of-buffer)))

(defun term-command (cmd)
  (term-line-mode)
  (insert cmd)
  (term-char-mode)
  (term-send-return))

(defun new-term ()
  (interactive)
  (let ((dir default-directory))
    (multi-term)
    (on-linux
     (sleep-for 0.5)
     (term-command (concat "cd " dir))
     (term-send-raw-string "\C-l"))))

(bind-key* "M-'" 'new-term)
(bind-key* "M-\"" 'get-term)

;; shell
(defun is-terminal? (buffer)
  (let ((name (buffer-name buffer)))
	(and (> (length name) 10)
		 (string= (substring name 0 10) "*terminal<"))))


(defun term-number (terminal-buffer)
  (string-to-number (substring (buffer-name terminal-buffer) 10 -2)))

(defun term-name (n)
  (concat "*terminal<" (number-to-string n) ">*"))

(defun next-in-list (n L)
  "smallest number greater than n in L. L should be sorted."
  (if (> (car L) n)
	  (car L)
	(next-in-list n (cdr L))))

(defun next-terminal ()
  "Next terminal name, numerically. Assumes we're in a terminal."
  (let ((term-buffers (remove-if-not 'is-terminal? (buffer-list)))
		(n (term-number (current-buffer))))
	(let ((term-numbers (sort (mapcar 'term-number term-buffers) '<)))
	  (term-name
	   (if (eq n (apply 'max term-numbers))
		   (car term-numbers) ; min
		   (next-in-list n term-numbers))))))


(defun get-term ()
  "Cycle through terminal buffers. If none exist, or we're visiting the only
  one, create one."
  (interactive)
  (let ((term-buffers (remove-if-not 'is-terminal? (buffer-list))))
	(let ((L (length term-buffers)))
	  (cond ((eq L 0) (new-term))
			((eq L 1)
			 (if (is-terminal? (current-buffer))
				 (new-term)
			     (switch-to-buffer (car term-buffers))))
			(t (if (is-terminal? (current-buffer))
				   (switch-to-buffer (next-terminal)) ; next buffer, numerically
				   (switch-to-buffer (car term-buffers))) ; last-used buffer
			   )))))


;; ;; don't intercept editing commands
(defun term-send-backward-kill-word ()
  "Backward kill word in term mode."
  (interactive)
  (term-send-raw-string "\C-w"))

(defun term-send-forward-kill-word ()
  "Kill word in term mode."
  (interactive)
  (term-send-raw-string "\ed"))

(defun term-send-backward-word ()
  "Move backward word in term mode."
  (interactive)
  (term-send-raw-string "\eb"))

(defun term-send-forward-word ()
  "Move forward word in term mode."
  (interactive)
  (term-send-raw-string "\ef"))

(bind-key "M-f" 'term-send-forward-word term-raw-map)
(bind-key "M-b" 'term-send-backward-word term-raw-map)
(bind-key "<M-backspace>" 'term-send-backward-kill-word term-raw-map)
(bind-key "C-p" 'term-send-up term-raw-map)
(bind-key "C-n" 'term-send-down term-raw-map)


;; M-d gets overwritten somehow
(add-hook 'term-mode-hook (lambda () (bind-key "M-d" 'term-send-forward-kill-word term-raw-map)))
