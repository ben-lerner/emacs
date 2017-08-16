; Mac
(if (eq system-type 'darwin)
	;; set command key to meta
	(setq mac-command-key-is-meta t
		  mac-command-modifier 'meta)
)

; Windows
;; is this the right test?
(if (or (eq system-type 'windows-nt)
		(eq system-type 'ms-dos))
	; set Windows key to meta
	(setq w32-lwindow-modifier 'meta))
