(require 'cl) ;; common-lisp stuff 
(require 'saveplace) ;; save place in file 

;; move all tildefiles to ~/.saves
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups


;; save place for emacs 25
(if (>= emacs-major-version 25)
  (save-place-mode 1)
  (setq-default save-place t))


;; set up melpa
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
    (package-initialize))


;; get packages that are missing
(defvar riccardo/packages '(gist
                            go-autocomplete
                            go-mode
                            haskell-mode
			    js2-mode
                            markdown-mode
                            scala-mode
			    sml-mode
                            solarized-theme
                            verilog-mode)
  "Default packages")


(defun riccardo/packages-installed-p ()
  (cl-loop for pkg in riccardo/packages
        when (not (package-installed-p pkg)) do (cl-return nil)
        finally (cl-return t)))

(unless (riccardo/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg riccardo/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))


;; no tabs plz
(setq tab-width 2
      indent-tabs-mode nil)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (go-eldoc flycheck go-autocomplete solarized-theme go-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; load solarized-light by default
(load-theme 'solarized-light)


;; follow symlinks automatically
(setq vc-follow-symlinks t)


;; go-mode, and go fmt before save

(require 'go-autocomplete)

(add-hook 'go-mode-hook
          (lambda ()
            (go-eldoc-setup)
            (add-hook 'before-save-hook 'gofmt-before-save)))


(defun sml-reload-file ()
  "Stop the SML repl and load the current file."
  (interactive)
  (when (get-buffer "*sml*")
    (with-current-buffer "*sml*"
      (when (get-buffer-process "*sml*")
        (kill-process sml-prog-proc--buffer)
        (erase-buffer))))
  (sleep-for 0.2)
  (sml-run "sml" "")
  (sml-prog-proc-load-file buffer-file-name t)
  (end-of-buffer))


(require 'sml-mode)
(add-hook 'sml-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-k") 'sml-reload-file)))

