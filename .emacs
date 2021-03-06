;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; author:   Malte Obbel Forsberg
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; initial setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/")
(require 'package)

;;(add-to-list 'package-archives
;;             '("marmalade" .
;;               "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://stable.melpa.org/packages/") t)

(package-initialize)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; look and feel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; set theme
(load-theme 'zenburn t)

;; don't display tool, scroll or menu bars
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; more intelligent buffer names in case of duplicates
(require 'uniquify)

;; show that pesky trailing whitespace
(setq-default show-trailing-whitespace t)

;; display column as well as row number
(setq column-number-mode t)

;; mark the whole active line
;;(global-hl-line-mode 1)

;; always display matching parentheses
(show-paren-mode t)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; minor functionality tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; always prefer utf-8
(prefer-coding-system 'utf-8)

;; automatically pair (), [], ""
;; TODO: why is it not pairing {}?
;; TODO: use electric-pair-mode instead in 24.4
(require 'autopair)
(autopair-global-mode) 

;; save place in file when restarting Emacs
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saved-places")

;; tab-with is 2 spaces, no tabs
(setq tab-width 2
      indent-tabs-mode nil)

;; yes or no questions can be answered by y/n instead
(defalias 'yes-or-no-p 'y-or-n-p)

;; save state of buffers every time Emacs quits
(desktop-save-mode 1)

;; move between windows using C-left, right etc
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; easy switching of buffer windows
(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; winner-mode switches to previous window state (e.g. undo splitting windows)
;; C-c left / right
(when (fboundp 'winner-mode)
  (winner-mode 1))

(global-set-key (kbd "M-S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "M-S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-S-C-<down>") 'shrink-window)
(global-set-key (kbd "M-S-C-<up>") 'enlarge-window)

;; use dired-x for extended functionality
(require 'dired-x)

;; define backup behaviour
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/backup_saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helper functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; functions to indent, remove tabs and otherwise clean up the buffer
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GnuPG setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'epa-file)
    (epa-file-enable)

(setq epg-gpg-program "C:/Program Files (x86)/GNU/GnuPG/gpg2.exe")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; god mode setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mostly from http://tuhdo.github.io/helm-intro.html

(require 'helm-config)

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)

;; rebind tab to do persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) 

;; make TAB works in terminal
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)

;; list actions using C-z
(define-key helm-map (kbd "C-z")  'helm-select-action)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h g") 'helm-google-suggest)

;; nicer buffer search
(global-set-key (kbd "M-i") 'helm-occur)

;; helm eshell functionality
(require 'helm-eshell)

(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))

;; C-c h l
(setq helm-locate-command "locate %s -e -A --regex %s") ;doesn't seem to work on windows with cygwin very well


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-mode configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org)

;; Load org-mode when editing file ending with .org
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; insert timestamp when a TODO was marked as DONE
(setq org-log-done t)

(setq org-agenda-include-diary t)

;; remember org clock between sessions
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; C-c a t only shows non-scheduled items
(setq org-agenda-show-log t
      org-agenda-todo-ignore-scheduled t
      org-agenda-todo-ignore-deadlines t)

;; capture templates for todos, journal entries and "word of the day"
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/GTD/gtd.org" "Tasks")
         "* TODO %^{Brief Description} %^g\n%?\nAdded: %U")
        ("j" "Journal" entry (file+datetree "~/GTD/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("w" "WOTD" entry (file "~/GTD/wotd.org")
         "* %^{German word} -- %^{English word} %^g\nEntered on %u %?")))

;; activate spell checking as well as writegood-mode when in org-mode
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (flyspell-mode)))
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (writegood-mode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ispell configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ispell)

;; If we're in Windows, add aspell to path
(when (eq system-type 'windows-nt)
  (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
  )

(setq ispell-program-name "aspell")

(global-set-key (kbd "<f8>") 'ispell-word)
(global-set-key (kbd "C-<f8>") 'flyspell-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'magit)
;; ugly solution because windows, github and ssh don't play well together
(setenv "GIT_ASKPASS" "git-gui--askpass")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; haskell-mode configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mostly from https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md
;; can use 'M-x haskell-mode-stylish-buffer' for nice formatting
;; some commands require 'happy' tool (?), install with cabal install happy

;; use haskell-indentation
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; go directly to the import section
(eval-after-load 'haskell-mode
          '(define-key haskell-mode-map [f9] 'haskell-navigate-imports))

;; to be able to jump to the definition of any field
(define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def-or-tag) ; ghci, otherwise fall back to TAGS file
;;(define-key haskell-mode-map (kbd "M-.") 'haskell-mode-tag-find) ; TAGS file
;;(define-key haskell-mode-map (kbd "M-.") 'haskell-mode-jump-to-def) ; ghci


;; 'cabal install hasktags' needed for this to work
(custom-set-variables
  '(haskell-tags-on-save t))

;; set some custom haskell process options
(custom-set-variables
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-log t))

;; set key shortcuts for interactive haskell in cabal and haskell
(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))

(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

;; compile and see output
(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))
(eval-after-load 'haskell-cabal
  '(define-key haskell-cabal-mode-map (kbd "C-c C-o") 'haskell-compile))

;; use cabal REPL instead of ghc
;;(custom-set-variables '(haskell-process-type 'cabal-repl))

;; custom haskell-mode settings
(custom-set-variables
 '(haskell-process-log t)
 '(haskell-process-type (quote cabal-repl)) ;; mui importante
 '(inferior-haskell-wait-and-jump t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ghc-mod configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 'cabal install ghc-mod' first
;; 'cabal install hlint' enables C-c C-c to select hlint instead of ghc
;; 'cabal install hoogle' and 'hoogle data' enables C-c C-h

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; add ghc (Haskell) backend
(add-to-list 'company-backends 'company-ghc)
;(custom-set-variables '(company-ghc-show-info t))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; writegood grading
(global-set-key "\C-c\C-gg" 'writegood-grade-level)
(global-set-key "\C-c\C-ge" 'writegood-reading-ease)


;; For work
;; (setq url-proxy-services
;;       '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;;         ("http" . "10.243.190.100:8080")
;;         ("https" . "10.243.190.100:8080")))

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
