(require 'tex-mode)
;; Run pdflatex on current buffer; defined in bash_scripts
;; Run make.sh for dse.
(defun ltx ()
  (interactive)
  (save-buffer)
  (let ((temp-buffer "*latex-output*"))
    (with-output-to-temp-buffer
     temp-buffer
     (shell-command
      (if (string-match "/distributed-systems-for-everyone/" default-directory)
          "cd ..; bash make.sh && open -g book.pdf"  ;; -g = don't change window focus
          "ltx")
      temp-buffer  ;; stdout
      "*Mesages*"  ;; stderr
      ))
    (pop-to-buffer temp-buffer)
    (help-mode)  ;; with-output-to-temp-buffer should use help-mode by default, but doesn't
    ))

(bind-key "C-c C-c" 'ltx tex-mode-map)

(add-hook 'latex-mode-hook (lambda () (electric-pair-mode 0)))
(add-hook 'text-mode-hook (lambda () (electric-pair-mode 0)))
