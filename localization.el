;; set OS key to meta

(on-mac
 (setq mac-command-key-is-meta t
       mac-command-modifier 'meta
       mac-option-modifier 'meta))

(on-linux
 (setq x-meta-keysym 'super))

(on-windows
 (setq w32-lwindow-modifier 'meta))
