(require 'package)
(setq inhibit-splash-screen t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(initial-scratch-message
   "
                            _____    ______________ 
                           |     |  /              \\  
                           | | | | <  hello world!  |
                           |_____|  \\______________/
                     ____ ___|_|___ ____ 
                    ()___)         ()___)
                    // /|           |\\ \\\\ 
                   // / |           | \\ \\\\ 
                  (___) |___________| (___)
                  (___)   (_______)   (___)
                  (___)     (___)     (___)
                  (___)      |_|      (___)
                  (___)  ___/___\\___   | |
                   | |  |           |  | |
                   | |  |___________| /___\\ 
                  /___\\  |||     ||| //  \\\\
                 //   \\\\ |||     ||| \\\\   //
                 \\\\   // |||     |||  \\\\ //
                  \\\\ // ()__)   (__()
                        ///       \\\\\\ 
                       ///         \\\\\\ 
                     _///___     ___\\\\\\_ 
                    |_______|   |_______|
")
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (vimish-fold company-ycmd whitespace-cleanup-mode ycmd emacs-ycmd evil-nerd-commenter which-key fzf auctex evil-leader helm solarized-theme projectile magit iedit evil-visual-mark-mode ##)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Assuming you wish to install "iedit" and "magit"
(ensure-package-installed 'iedit 'magit 'evil 'projectile 'helm
			  'auctex 'which-key 'ycmd 'evil-nerd-commenter
			  'whitespace-cleanup-mode 'company-ycmd 'vimish-fold
			  )

(require 'vimish-fold)
;; Activate installed packages
(package-initialize)

(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "C-t") 'fzf)
(global-linum-mode 1) ;always show line numbers

;;company-mode for YouCompleteMe
(require 'company-ycmd)
(company-ycmd-setup)

;;Evil-Mode shit:
(require 'evil)
(require 'evil-leader)
(global-evil-leader-mode)
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-insert-state-map (kbd "C-u")
  (lambda ()
    (interactive)
    (evil-delete (point-at-bol) (point))))
(define-key evil-insert-state-map (kbd "C-<SPC>") 'evil-normal-state)
;;evil leader keybindings
(evil-leader/set-key
  "x" 'helm-M-x
  "t" 'fzf)
;; evil-nerd-commenter:
(defun matlab-mode-hook-config ();;required for matlab
  (local-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines))
(add-hook 'matlab-mode-hook 'matlab-mode-hook-config)
(global-set-key (kbd "C-c c") 'evilnc-comment-or-uncomment-lines)
(global-set-key (kbd "C-c p") 'evilnc-comment-or-uncomment-paragraphs)

(require 'which-key)
(which-key-mode)
(evil-mode 1)

;;YCMD
(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)
(set-variable 'ycmd-extra-conf-whitelist '("~/sandbox/*"))

