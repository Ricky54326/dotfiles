(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")))
(package-initialize)
(package-refresh-contents)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package helm
  :ensure t
  :pin melpa
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100
          helm-idle-delay 0.0
          helm-input-idle-delay 0.01
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t)
    (helm-mode))
  :bind (("C-x C-f" . helm-find-files)
         ("C-c h" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x b" . helm-buffers-list)
         ("C-x C-b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)))
(ido-mode -1)

(use-package projectile
  :ensure t
  :pin melpa
  :demand t
  :commands projectile-global-mode
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  ;; Use C-c C-f to find a file anywhere in the current project.
  :bind ("C-c C-f" . projectile-find-file)
  :diminish projectile-mode)

(use-package undo-tree
  :ensure t
  :pin melpa
  :diminish undo-tree-mode
  :config (global-undo-tree-mode)
  :bind ("s-/" . undo-tree-visualize))

(use-package magit
  :ensure t
  :pin melpa
  :commands magit-status
  :bind ("C-x g" . magit-status))

(use-package which-key
  :ensure t
  :pin melpa
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

(setq vc-follow-symlinks t)
(setq kept-new-versions 10
      kept-old-versions 0
      delete-old-versions t
      backup-by-copying t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)


(defun split-and-move-vertically ()
  "Split the window vertically and move to the new frame"
  (interactive)
  (split-window-vertically)
  (windmove-down))

(defun split-and-move-horizontally ()
  "Split the window horizontally and move to the new frame"
  (interactive)
  (split-window-horizontally)
  (windmove-right))

(global-set-key [mouse-8] 'previous-buffer)
(global-set-key [mouse-9] 'next-buffer)
(global-set-key (kbd "C-x 2") 'split-and-move-vertically)
(global-set-key (kbd "C-x 3") 'split-and-move-horizontally)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(show-paren-mode 1)

(setq inhibit-startup-screen t)

(global-set-key (kbd "C-x k") 'kill-this-buffer)

(setq backup-directory-alist `(("." . "~/.saves")))

(global-set-key (kbd "C-c /") 'comment-region)
(global-set-key (kbd "C-c ?") 'uncomment-region)

(defun jump-to-dotemacs ()
  "Open .emacs in a buffer"
  (interactive)
  (find-file "~/.emacs"))

(global-set-key (kbd "C-c d") 'jump-to-dotemacs)

(use-package solarized-theme
  :ensure t
  :pin melpa
  :config
  (load-theme 'solarized-light t))

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

(use-package sml-mode
  :ensure t
  :pin gnu
  :bind (:map sml-mode-map
              ("C-c C-k" . sml-reload-file)))


;; save place for emacs 25
(if (>= emacs-major-version 25)
  (save-place-mode 1)
  (setq-default save-place t))


(use-package exec-path-from-shell
  :ensure t
  :pin melpa
  :config
  (exec-path-from-shell-initialize))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (sml-mode solarized-theme which-key magit undo-tree projectile helm use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
