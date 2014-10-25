;; initial setup

(add-to-list 'load-path "~/.emacs.d/")
(require 'package)

(prefer-coding-system 'utf-8)

;;(add-to-list 'package-archives
;;             '("marmalade" .
;;               "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(require 'saveplace)
(require 'ispell)
(require 'org)
(require 'uniquify)
(require 'autopair)
(require 'magit)

; GnuPG path
(require 'epa-file)
    (epa-file-enable)

(setq epg-gpg-program "C:/Program Files (x86)/GNU/GnuPG/gpg2.exe")

;; enable god-mode with ESC
;; g = M, G = C-M, C not needed
;; 12f = M-12 C-f
;; gf.. = M-f M-f M-f (. = repetition)
;; uco = C-u C-c C-o
(require 'god-mode)

(global-set-key (kbd "<escape>") 'god-mode-all)
(defun my-update-cursor ()
  (setq cursor-type (if (or god-local-mode buffer-read-only)
                        'bar
                      'box)))

(add-hook 'god-mode-enabled-hook 'my-update-cursor)
(add-hook 'god-mode-disabled-hook 'my-update-cursor)

(autopair-global-mode) ; use electric-pair-mode instead in 24.4

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(global-set-key (kbd "C-c n") 'cleanup-buffer)

(setq-default show-trailing-whitespace t)

;;(require 'tabbar)
;;(tabbar-mode t)

;; move between windows using C-left, right etc
;; doesn't play nice with org-mode though
;;(when (fboundp 'windmove-default-keybindings)
;;  (windmove-default-keybindings))

(setq column-number-mode t)

(setq tab-width 2
      indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(load-theme 'zenburn t)

;; winner-mode => C-c left / right
(when (fboundp 'winner-mode)
  (winner-mode 1))

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)

;;(global-hl-line-mode 1)

(show-paren-mode t)

;; ;For work
;; (setq url-proxy-services
;;       '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;;         ("http" . "10.243.190.100:8080")
;;         ("https" . "10.243.190.100:8080")))


;; Helm configuration
(require 'helm-config)

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-x b") 'helm-mini)

(global-set-key (kbd "C-x C-f") 'helm-find-files)

(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)

(global-set-key (kbd "C-c h g") 'helm-google-suggest)

(require 'helm-eshell)

(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))

;; Helm-swoop
;;(require 'helm-swoop)

(global-set-key (kbd "M-i") 'helm-occur)
;; (global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
;; (global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
;; (global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; ;; When doing isearch, hand the word over to helm-swoop
;; (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; ;; From helm-swoop to helm-multi-swoop-all
;; (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; ;; When doing evil-search, hand the word over to helm-swoop
;; ;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

;; ;; Save buffer when helm-multi-swoop-edit complete
;; (setq helm-multi-swoop-edit-save t)

;; ;; If this value is t, split window inside the current window
;; (setq helm-swoop-split-with-multiple-windows nil)

;; ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
;; (setq helm-swoop-split-direction 'split-window-vertically)

;; ;; If nil, you can slightly boost invoke speed in exchange for text color
;; (setq helm-swoop-speed-or-color 1)

;; ;; Optional face for each line number
;; ;; Face name is `helm-swoop-line-number-face`
;; (setq helm-swoop-use-line-number-face t)


                                        ; Save state of buffers everytime Emacs quits
(desktop-save-mode 1)

                                        ; remove tool bar
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; -- save place in file
(setq-default save-place t)

;; Load org-mode when editing file ending with .org
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-include-diary t)

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


;; If we're in Windows, add aspell to path
(when (eq system-type 'windows-nt)
  (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
  )

(setq ispell-program-name "aspell.exe")

(global-set-key (kbd "<f8>") 'ispell-word)
(global-set-key (kbd "C-<f8>") 'flyspell-mode)

;; Org-mode

;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (flyspell-mode)))
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (writegood-mode)))

(global-set-key "\C-c\C-gg" 'writegood-grade-level)
(global-set-key "\C-c\C-ge" 'writegood-reading-ease)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("3b819bba57a676edf6e4881bd38c777f96d1aa3b3b5bc21d8266fa5b0d0f1ebf" default)))
 '(org-agenda-custom-commands (quote (("n" "Agenda and all TODO's" ((agenda "") (alltodo))) ("w" todo "WAITING") ("W" todo-tree "WAITING"))))
 '(org-agenda-files (quote ("~/GTD/gtd.org")))
 '(org-archive-location "%s_archive::")
 '(org-refile-targets (quote (("~/GTD/gtd.org" :maxlevel . 1) ("~/GTD/someday.org" :level . 2)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(setq org-agenda-show-log t
      org-agenda-todo-ignore-scheduled t
      org-agenda-todo-ignore-deadlines t)

(setq org-agenda-include-diary t)

(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/GTD/gtd.org" "Tasks")
         "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
        ("j" "Journal" entry (file+datetree "~/GTD/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("w" "WOTD" entry (file "~/GTD/wotd.org")
         "* %^{German word} -- %^{English word} %^g\nEntered on %u %?")))

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)
