(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(when (equal system-name "Kavins-Air.Dlink")
  (use-package dashboard
    :diminish
    (dashboard-mode page-break-lines-mode)
    :config
    (dashboard-setup-startup-hook)
    (setq dashboard-banner-logo-title "Hey Kavin! Don't forget to see your agendas: M-x org-agenda-list")
    (setq dashboard-items '((recents . 2)
                            (projects . 2)
                            (agenda . 10)))
    (setq dashboard-set-file-icons t)
    (setq dashboard-set-heading-icons t)
    (setq dashboard-week-agenda t)
    (setq dashboard-startup-banner 'logo)
    :custom-face
    (dashboard-heading ((t (:foreground "#fff" :weight bold))))
    ))

(setq rune/is-termux
      (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                           ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize))

(use-package autothemer
  :ensure t)

(setq inhibit-startup-message t)

(unless rune/is-termux
  (scroll-bar-mode -1)        ; Disable visible scrollbar
  (tool-bar-mode -1)          ; Disable the toolbar
  (tooltip-mode -1)           ; Disable tooltips
  (set-fringe-mode 10))        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

(setq initial-scratch-message "; Hi Kavin. C-x C-f eh" ) ; Message on Scratch Buffer

(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Set up the visible bell
(when (equal system-name "Kavins-Air.Dlink")
  (setq visible-bell nil
        ring-bell-function 'double-flash-mode-line)
  (defun double-flash-mode-line ()
    (let ((flash-sec (/ 1.0 20)))
      (invert-face 'mode-line)
      (run-with-timer flash-sec nil #'invert-face 'mode-line)
      (run-with-timer (* 2 flash-sec) nil #'invert-face 'mode-line)
      (run-with-timer (* 3 flash-sec) nil #'invert-face 'mode-line))))

(when (equal system-name "kavin-pc")
  (setq visible-bell t))

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                vterm-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(defvar runemacs/default-font-size 135)

(when (equal system-name "Kavins-Air.Dlink")
    (set-face-attribute 'default nil :font "MesloLGS NF" :height runemacs/default-font-size)
    (set-face-attribute 'fixed-pitch nil :font "MesloLGS NF" :height 140)
)
(when (equal system-name "kavin-pc")
    (set-face-attribute 'default nil :font "Fira Code Retina" :height runemacs/default-font-size)
    (set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 140)
)
(set-face-attribute 'variable-pitch nil :family "Cantarell" :height 160 :weight 'regular)

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 15))

(use-package hide-mode-line)

(use-package doom-themes :defer t)
;; (use-package spacemacs-theme :defer t)
(load-theme 'doom-dracula t)
;; (load-theme 'spacemacs-dark t)
;; (load-theme 'doom-palenight t)
(load-theme 'doom-horizon t)
;; (load-theme 'doom-acario-dark t)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(defun dw/dont-arrow-me-bro ()
  (interactive)
  (message "Arrow keys are bad, you know?"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (unless rune/is-termux                                       
    (define-key evil-normal-state-map (kbd "<left>") 'dw/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<right>") 'dw/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<down>") 'dw/dont-arrow-me-bro)
    (define-key evil-normal-state-map (kbd "<up>") 'dw/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<left>") 'dw/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<right>") 'dw/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<down>") 'dw/dont-arrow-me-bro)
    (evil-global-set-key 'motion (kbd "<up>") 'dw/dont-arrow-me-bro))

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ("C-M-j" . counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package smex ;; Adds M-x recent command sorting for counsel-M-x
  :defer 1
  :after counsel)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package autopair)
(autopair-global-mode)

(use-package evil-smartparens
  :hook (smartparens-enabled-hook . evil-smartparens-mode)
  (prog-mode . evil-smartparens-mode))

(use-package emmet-mode
  :mode "\\.edge\\'"
  :diminish (emmet-mode . "ε")
  :bind* (("C-)" . emmet-next-edit-point)
          ("C-(" . emmet-prev-edit-point)
          ("M-<tab>" . emmet-expand-line))
  :commands (emmet-mode
             emmet-next-edit-point
             emmet-prev-edit-point)
  :init
  (setq emmet-indentation 2)
  (setq emmet-move-cursor-between-quotes t)
  :config
  ;; Auto-start on any markup modes
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook 'emmet-mode)
  (setq emmet-expand-jsx-className? nil)  ;; Set to nil because className was being used in non-jsx files too
  (setq emmet-self-closing-tag-style " /"))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "h" '(:ignore t :which-key "Hydra")
  "hs" '(hydra-text-scale/body :which-key "Scale Text"))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org-bullets
  ;; :if (not rune/is-termux) 
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :ensure org-plus-contrib
  :config
  (setq org-ellipsis " ▾")

  (setq org-src-fontify-natively t)

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

(when (equal system-name "Kavins-Air.Dlink")
  (setq org-agenda-files
        '("~/Notes/Tasks.org"
          "~/Notes/Birthdays.org"
          "~/Documents/10N/preboards.org"
          "~/Notes/Calendar.org")))

(when (equal system-name "Kavins-Air.Dlink")
  (setq
   org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1))))

  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (efs/org-font-setup))

(setq org-tag-alist
  '((:startgroup)
     ; Put mutually exclusive tags here
     (:endgroup)

     ("@school" . ?S)
     ("@home" . ?H)
     ("@tricycle" . ?T)
     ("@fiitjee" . ?F)
     ("planning" . ?p)
     ("study" . ?s)
     ("note" . ?n)
     ("idea" . ?i)))

(setq org-agenda-custom-commands
 '(("d" "Dashboard"
   ((agenda "" ((org-deadline-warning-days 7)))
    (todo "TODO"
      ((org-agenda-overriding-header "TODO Tasks")))
    (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

  ("n" "TODO Tasks"
   ((todo "TODO"
      ((org-agenda-overriding-header "Todo Tasks")))))

  ("T" "Tricycle Tasks" tags-todo "+@tricycle")

  ("S" "School Tasks" tags-todo "+@school")

  ("s" "Study Planning" tags-todo "+study-planning")

  ;; Low-effort next actions
  ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
   ((org-agenda-overriding-header "Low Effort Tasks")
    (org-agenda-max-todos 20)
    (org-agenda-files org-agenda-files)))

  ("w" "Workflow Status"
   ((todo "WAIT"
          ((org-agenda-overriding-header "Waiting on External")
           (org-agenda-files org-agenda-files)))
    (todo "REVIEW"
          ((org-agenda-overriding-header "In Review")
           (org-agenda-files org-agenda-files)))
    (todo "PLAN"
          ((org-agenda-overriding-header "In Planning")
           (org-agenda-todo-list-sublevels nil)
           (org-agenda-files org-agenda-files)))
    (todo "BACKLOG"
          ((org-agenda-overriding-header "Project Backlog")
           (org-agenda-todo-list-sublevels nil)
           (org-agenda-files org-agenda-files)))
    (todo "READY"
          ((org-agenda-overriding-header "Ready for Work")
           (org-agenda-files org-agenda-files)))
    (todo "ACTIVE"
          ((org-agenda-overriding-header "Active Projects")
           (org-agenda-files org-agenda-files)))
    (todo "COMPLETED"
          ((org-agenda-overriding-header "Completed Projects")
           (org-agenda-files org-agenda-files)))
    (todo "CANC"
          ((org-agenda-overriding-header "Cancelled Projects")
           (org-agenda-files org-agenda-files)))))))

(setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/Notes/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/Notes/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/Notes/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/Notes/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)))

(define-key global-map (kbd "C-c j")
  (lambda () (interactive) (org-capture nil "jj")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package ob-dart)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (js . t)
   (sql . t)
   (dart . t)
   (calc . t)
   (lua . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(use-package org-special-block-extras
  :ensure t
  :hook (org-mode . org-special-block-extras-mode))

(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("temp" . "src"))
(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("js" . "src js"))
(add-to-list 'org-structure-template-alist '("html" . "src html"))
(add-to-list 'org-structure-template-alist '("sql" . "src sql"))
(add-to-list 'org-structure-template-alist '("rust" . "src rust"))
(add-to-list 'org-structure-template-alist '("lua" . "src lua"))
(add-to-list 'org-structure-template-alist '("dart" . "src dart"))

(defun efs/org-babel-tangle-config ()
  (let ((org-confirm-babel-evaluate nil))
    (org-babel-tangle)))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package org-alert
  :ensure t
   :custom (alert-default-style 'osx-notifier)
   :config
   (setq org-alert-interval 1800
         org-alert-notification-title "Reminder!")
   (org-alert-enable))

(use-package org-wild-notifier
  :ensure t
  :custom
  (alert-default-style 'osx-notifier)
  (org-wild-notifier-alert-time '(1 10 30))
  (org-wild-notifier-keyword-whitelist '("TODO"))
  (org-wild-notifier-notification-title "Org Wild Reminder!")
  :config
  (org-wild-notifier-mode 1))

(defun rune/presentation-setup ()
  (setq text-scale-mode-amount 3)
  (org-display-inline-images)
  (hide-mode-line-mode 1)
  (text-scale-mode 1))

(defun rune/presentation-end ()
  (hide-mode-line-mode 0)
  (text-scale-mode 0))

(use-package org-tree-slide
  :hook ((org-tree-slide-play . rune/presentation-setup)
         (org-tree-slide-stop . rune/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect t)
  (org-tree-slide-activate-message "Presentation Started")
  (org-tree-slide-deactivate-message "Presentation finished!")
  (org-tree-slide-header t)
  (org-tree-slide-breadcrumbs " // ")
  (org-image-actual-width nil))

(use-package markdown-mode
  ;; :pin melpa-stable
  :mode "\\.md\\'"
  :config
  (defun dw/set-markdown-header-font-sizes ()
  (font-lock-add-keywords 'markdown-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
    (dolist (face '((markdown-header-face-1 . 1.2)
                    (markdown-header-face-2 . 1.1)
                    (markdown-header-face-3 . 1.0)
                    (markdown-header-face-4 . 1.0)
                    (markdown-header-face-5 . 1.0)))
      (set-face-attribute (car face) nil :font "Cantarell" :weight 'normal :height (cdr face)))
    (set-face-attribute 'markdown-code-face nil :inherit '(shadow fixed-pitch)))

  (defun rune/markdown-mode-hook ()
    (dw/set-markdown-header-font-sizes))

  (add-hook 'markdown-mode-hook 'rune/markdown-mode-hook))

(use-package ox-reveal
  :ensure t
  :config
  (require 'ox-reveal)
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
  (setq org-reveal-mathjax t))

(use-package htmlize
  :ensure t)

(use-package emojify
:hook (after-init . global-emojify-mode)
:commands emojify-mode)

(use-package counsel-osx-app
  :bind* ("S-M-SPC" . counsel-osx-app)
  :commands counsel-osx-app
  :config
  (setq counsel-osx-app-location
        (list "/Applications"
              "/Applications/Misc"
              "/Applications/Utilities"
              (expand-file-name "~/Applications")
              (expand-file-name "~/.nix-profile/Applications")
              "/Applications/Xcode.app/Contents/Applications")))

(use-package elcord
  :ensure t
  :disabled rune/is-termuxk
  :custom
  (elcord-display-buffer-details nil)
  :config
  (elcord-mode))

(use-package speed-type
  :ensure t)

(defun rune/bluetooth-connect-philips ()
  (interactive)
  (start-process-shell-command "blueutil" nil "blueutil --connect a4-77-58-7a-2d-7d"))


(rune/leader-keys
  "b" '(:ignore t :which-key "Bluetooth")
  "bc" '(:ignore t :which-key "connect")
  "bcp" '(rune/bluetooth-connect-philips :which-key "Philips SHB3075"))

(defun rune/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode)
   (lsp))

 (use-package lsp-mode
   :ensure t
   :bind (:map lsp-mode-map
               ("TAB" . completion-at-point))
   :commands (lsp lsp-deffered)
   :hook (lsp-mode . rune/lsp-mode-setup)
   :init
   (setq lsp-keymap-prefix "C-c s-p")
   :config
   (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-ivy)

(use-package lsp-treemacs
    :init (treemacs-display-current-project-exclusively)
    :after lsp)

(rune/leader-keys
  "t" '(:ignore t :which-key "Treemacs")
  "to" 'treemacs
  "tt" 'treemacs-display-current-project-exclusively)

(use-package dap-mode)

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(defun rune/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :mode "\\.js\\'"
  :hook (js2-mode . lsp-deferred)
  :config
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))
  (setq js2-mode-show-strict-warnings nil)
  (add-hook 'js2-mode-hook #'rune/set-js-indentation)
  (add-hook 'json-mode-hook #'rune/set-js-indentation)
  (require 'dap-node)
  (dap-node-setup))

(use-package prettier-js
  :hook ((js2-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode))
  :config
  (setq prettier-js-show-errors nil))

(use-package jade-mode
  :mode "\\.pug\\'")
  ;; :hook (jade-mode . lsp-deferred))

(use-package web-mode
  :mode "(\\.\\(html?\\|ejs\\|tsx\\|js[x]?\\|edge\\)\\'"
  :hook (web-mode . lsp-deferred)
  :config
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-attribute-indent-offset 2))

;; 1. Start the server with `httpd-start'
;; 2. Use `impatient-mode' on any buffer
(use-package impatient-mode
  :ensure t)

(use-package skewer-mode
  :ensure t)

(use-package css-mode
  :mode "\\.css\\'"
  :hook (css-mode . lsp-deferred)
  :config
  (setq css-indent-offset 2))

(use-package scss-mode
  :mode "\\.scss\\'"
  :hook (scss-mode . lsp-deferred)
  :config
  (setq scss-output-directory "../css")
  (setq scss-compile-at-save t))

;; (use-package lsp-python-ms
  ;;   :ensure t
  ;;   :init (setq lsp-python-ms-auto-install-server t)
  ;;   :hook (python-mode . (lambda ()
  ;;                          (require 'lsp-python-ms)
  ;;                           (lsp-deferred))))

(use-package python-mode
  :ensure t 
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3"))

(use-package yaml-mode
  :hook (scss-mode . lsp-deferred)
  :mode "\\.ya?ml\\'")

(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

(use-package company
    :after lsp-mode
    :hook ((lsp-mode . company-mode)
           (eldoc-mode . company-mode))
    :bind (:map company-active-map
                ("<tab>" . company-complete-selection))
    (:map lsp-mode-map
          ("<tab>" . company-indent-or-complete-common))
    :custom
    (company-minimum-prefix-length 1)
    (company-idle-delay 0.0))

  (use-package company-box
    :diminish
    :functions (all-the-icons-faicon
                all-the-icons-material
                all-the-icons-octicon
                all-the-icons-alltheicon)
    :hook (company-mode . company-box-mode)
    :init (setq company-box-enable-icon (display-graphic-p))
    :config
    (setq company-box-backends-colors nil))

(use-package projectile
    :diminish projectile-mode
    :config (projectile-mode)
    :custom ((projectile-completion-system 'ivy))
    :bind-keymap
    ("C-c p" . projectile-command-map)
    :init
    (when (file-directory-p "~/Documents/projects")
      (setq projectile-project-search-path '("~/Documents/projects")))
    (setq projectile-switch-project-action #'projectile-dired))

  (use-package counsel-projectile
    :config (counsel-projectile-mode))

(use-package magit
     :custom
     (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-magit
     :after magit)

(setq auth-sources '("~/.authinfo"))

  (when (equal system-name "Kavins-Air.Dlink")
 (use-package forge))

(use-package git-gutter
  :diminish
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode))
  :config
  (setq git-gutter:update-interval 2)
  (require 'git-gutter-fringe)
  (set-face-foreground 'git-gutter-fr:added "LightGreen")
  (fringe-helper-define 'git-gutter-fr:added nil
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        ".........."
                        ".........."
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        ".........."
                        ".........."
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:modified "LightGoldenrod")
  (fringe-helper-define 'git-gutter-fr:modified nil
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        ".........."
                        ".........."
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        ".........."
                        ".........."
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX")

  (set-face-foreground 'git-gutter-fr:deleted "LightCoral")
  (fringe-helper-define 'git-gutter-fr:deleted nil
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        ".........."
                        ".........."
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        ".........."
                        ".........."
                        "XXXXXXXXXX"
                        "XXXXXXXXXX"
                        "XXXXXXXXXX")

  ;; These characters are used in terminal mode
  (setq git-gutter:modified-sign "≡")
  (setq git-gutter:added-sign "≡")
  (setq git-gutter:deleted-sign "≡")
  (set-face-foreground 'git-gutter:added "LightGreen")
  (set-face-foreground 'git-gutter:modified "LightGoldenrod")
  (set-face-foreground 'git-gutter:deleted "LightCoral"))

(use-package lorem-ipsum
  :ensure t
  :config
  (lorem-ipsum-use-default-bindings))

(use-package evil-nerd-commenter
  :bind ("s-/" . evilnc-comment-or-uncomment-lines))

(use-package comment-tags
  :init
 (autoload 'comment-tags-mode "comment-tags-mode")
  (setq comment-tags-keyword-faces
        `(("TODO" . ,(list :weight 'bold :foreground "#28ABE3"))
          ("BUG" . ,(list :weight 'bold :foreground "#DB3340"))
          ("INFO" . ,(list :weight 'bold :foreground "#F7EAC8"))
          ("DONE" . ,(list :weight 'bold :foreground "#1FDA9A"))))
  (setq comment-tags-keymap-prefix (kbd "C-c t"))
  (setq comment-tags-comment-start-only t
        comment-tags-require-colon t
        comment-tags-case-sensitive t
        comment-tags-show-faces t
        comment-tags-lighter nil)
  :config
  (add-hook 'prog-mode-hook 'comment-tags-mode))

(rune/leader-keys
  "r" '(:ignore t :which-key "Rename")
  "rf" 'rename-file)

(use-package darkroom
  :commands darkroom-mode
  :config
  (setq darkroom-text-scale-increase 0))

(defun rune/enter-focus-mode ()
  (interactive)
  (darkroom-mode 1)
  (display-line-numbers-mode 0))

(defun rune/leave-focus-mode ()
  (interactive)
  (darkroom-mode 0)
  (display-line-numbers-mode 1))

(defun rune/toggle-focus-mode ()
  (interactive)
  (if (symbol-value darkroom-mode)
    (rune/leave-focus-mode)
    (rune/enter-focus-mode)))

(rune/leader-keys
  "tf" '(rune/toggle-focus-mode :which-key "focus mode"))

(when (equal system-name "Kavins-Air.Dlink")
(use-package ivy-pass
  :commands ivy-pass
  :config
  (setq password-store-password-length 12)
  (setq epa-file-cache-passphrase-for-symmetric-encryption nil))

(use-package auth-source-pass
  :config
  (auth-source-pass-enable))

(rune/leader-keys
  "p" '(:ignore t :which-key "pass")
  "pp" 'ivy-pass
  "pi" 'password-store-insert
  "pg" 'password-store-generate))

;; (use-package org-gcal
;;      :after org
;;      :config

;;      (setq org-gcal-client-id (password-store-get "API/Google/kavinvalli-emacs-id")
;;            org-gcal-client-secret (password-store-get "API/Google/kavinvalli-emacs-secret")
;;            org-gcal-file-alist '(("kavinvalli@gmail.com" . "~/Notes/Calendar.org"))))

;; (rune/leader-keys
;;   "c" '(:ignore t :which-key "calendar")
;;   "cs" '(org-gcal-fetch :which-key "sync")
;;   "cp" '(org-gcal-post-at-point :which-key "post"))

(when (equal system-name "Kavins-Air.Dlink")
(use-package counsel-spotify
  :after ivy
  :config
  (setq counsel-spotify-client-id (password-store-get "API/Spotify/kavinvalli-emacs-id"))
  (setq counsel-spotify-client-secret (password-store-get "API/Spotify/kavinvalli-emacs-secret")))

(rune/leader-keys
  "s" '(:ignore t :which-key "Counsel Spotify")
  "ss" '(:ignore t :which-key "Search")
  "ssp" '(counsel-spotify-search-playlist :which-key "Search Playlist")
  "sst" '(counsel-spotify-search-track :which-key "Search Track")
  "sp" '(counsel-spotify-toggle-play-pause :which-key "Toggle Play Pause")
  "sa" '(counsel-spotify-search-album :which-key "Search Album")
  "s>" '(counsel-spotify-next :which-key "Next")
  "s<" '(counsel-spotify-previous :which-key "Previous")))

(when (equal system-name "Kavins-Air.Dlink")
(use-package ivy-youtube
  :config
  (setq ivy-youtube-key (password-store-get "API/Youtube/kavinvalli-emacs-api-key")))

(rune/leader-keys
  "y" '(ivy-youtube :which-key "Ivy Youtube")))

(use-package term
  :config
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(defun read-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun rune/get-current-package-version ()
  (interactive)
  (let ((package-json-file (concat (eshell/pwd) "/package.json")))
    (when (file-exists-p package-json-file)
      (let* ((package-json-contents (read-file package-json-file))
             (package-json (ignore-errors (json-parse-string package-json-contents))))
        (when package-json
          (ignore-errors (gethash "version" package-json)))))))

(defun rune/get-prompt-path ()
  (let* ((current-path (eshell/pwd))
         (git-output (shell-command-to-string "git rev-parse --show-toplevel"))
         (has-path (not (string-match "^fatal" git-output))))
    (if (not has-path)
        (abbreviate-file-name current-path)
      (string-remove-prefix (file-name-directory git-output) current-path))))

(defun rune/eshell-prompt ()
  (let ((current-branch (magit-get-current-branch))
        (package-version (rune/get-current-package-version)))
    (concat
     "\n"
     (propertize (system-name) 'face `(:foreground "#62aeed"))
     (propertize " ॐ " 'face `(:foreground "white"))
     (propertize (rune/get-prompt-path) 'face `(:foreground "#82cfd3"))
     (when current-branch
       (concat
        (propertize " • " 'face `(:foreground "white"))
        (propertize (concat " " current-branch) 'face `(:foreground "#c475f0"))))
     (when package-version
       (concat
        (propertize " @ " 'face `(:foreground "white"))
        (propertize package-version 'face `(:foreground "#e8a206"))))
     (propertize " • " 'face `(:foreground "white"))
     (propertize (format-time-string "%I:%M:%S %p") 'face `(:foreground "#5a5b7f"))
     (if (= (user-uid) 0)
         (propertize "\n#" 'face `(:foreground "red2"))
       (propertize "\nλ" 'face `(:foreground "#aece4a")))
     (propertize " " 'face `(:foreground "white")))))

(defun rune/configure-eshell ()
  (require 'evil-collection-eshell)
  (evil-collection-eshell-setup)
  (use-package xterm-color)
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  (add-hook 'eshell-before-prompt-hook
            (lambda ()
              (setq xterm-color-preserve-properties t)))

  (add-hook 'eshell-pre-command-hook
            '(lambda () (setenv "TERM" "xterm-256color")))
  (add-hook 'eshell-post-command-hook
            '(lambda () (setenv "TERM" "dumb")))

  (define-key eshell-mode-map (kbd "<tab>") 'completion-at-point)

  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-prompt-regexp        "^λ "
        eshell-highlight-prompt t
        eshell-hist-ignoredups t
        eshell-prompt-function 'rune/eshell-prompt))
        ;; eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt)

(use-package eshell
  :hook (eshell-first-time-mode . rune/configure-eshell)
  :config
  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "nvim")))
  (eshell-git-prompt-use-theme 'powerline))

(rune/leader-keys
  "SPC" '(eshell :which-key "Eshell"))

(use-package fish-completion
  :hook (eshell-mode . fish-completion-mode))

(use-package eshell-syntax-highlighting
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode +1))

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode)
  ;; :hook (eshell-mode-hook . esh-autosuggest-mode)
  :config
  (setq esh-autosuggest-use-company-map t)
  (set-face-foreground 'company-preview-common "#4b5668")
  (set-face-background 'company-preview nil))

(use-package eshell-toggle
  :bind ("C-M-'" . eshell-toggle)
  :custom
  (eshell-toggle-size-fraction 3)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil))

(use-package bufler
  :ensure t
  :bind (("C-M-j" . bufler-switch-buffer)
         ("C-M-k" . bufler-workspace-frame-set))
  :config
  (evil-collection-define-key 'normal 'bufler-list-mode-map
    (kbd "RET")   'bufler-list-buffer-switch
    (kbd "M-RET") 'bufler-list-buffer-peek
    "D"           'bufler-list-buffer-kill)

  (setq bufler-groups
        (bufler-defgroups
          ;; Subgroup collecting all named workspaces.
          (group (auto-workspace))
          ;; Subgroup collecting buffers in a projectile project.
          (group (auto-projectile))
          ;; Grouping browser windows
          (group
           (group-or "Browsers"
                     (name-match "Vimb" (rx bos "vimb"))
                     (name-match "Qutebrowser" (rx bos "Qutebrowser"))
                     (name-match "Chromium" (rx bos "Chromium"))))
          (group
           (group-or "Chat"
                     (mode-match "Telega" (rx bos "telega-"))))
          (group
           ;; Subgroup collecting all `help-mode' and `info-mode' buffers.
           (group-or "Help/Info"
                     (mode-match "*Help*" (rx bos (or "help-" "helpful-")))
                     ;; (mode-match "*Helpful*" (rx bos "helpful-"))
                     (mode-match "*Info*" (rx bos "info-"))))
          (group
           ;; Subgroup collecting all special buffers (i.e. ones that are not
           ;; file-backed), except `magit-status-mode' buffers (which are allowed to fall
           ;; through to other groups, so they end up grouped with their project buffers).
           (group-and "*Special*"
                      (name-match "**Special**"
                                  (rx bos "*" (or "Messages" "Warnings" "scratch" "Backtrace" "Pinentry") "*"))
                      (lambda (buffer)
                        (unless (or (funcall (mode-match "Magit" (rx bos "magit-status"))
                                             buffer)
                                    (funcall (mode-match "Dired" (rx bos "dired"))
                                             buffer)
                                    (funcall (auto-file) buffer))
                          "*Special*"))))
          ;; Group remaining buffers by major mode.
          (auto-mode))))

(when (equal system-name "Kavins-Air.Dlink")
  (use-package dired
    :ensure nil
    :commands (dired dired-jump)
    :bind (("C-x C-j" . dired-jump))
    :custom ((dired-listing-switches "-agho --group-directories-first")
             (insert-directory-program "/usr/local/bin/gls")
             (delete-by-moving-to-trash t))
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-single-up-directory
      "l" 'dired-single-buffer)))

(when (equal system-name "kavin-pc")
  (use-package dired
    :ensure nil
    :commands (dired dired-jump)
    :bind (("C-x C-j" . dired-jump))
    :custom ((dired-listing-switches "-agho --group-directories-first")
             (delete-by-moving-to-trash t))
    :config
    (evil-collection-define-key 'normal 'dired-mode-map
      "h" 'dired-single-up-directory
      "l" 'dired-single-buffer)))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("png" . "open")
                                ("jpg" . "open")
                                ("jpeg" . "open")
                                ("pdf" . "open")
                                ("mov" . "open")
                                ("html" . "open"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(use-package dired-rainbow
  :config
  (progn
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")
    ))

(use-package calfw
  :disabled
  :commands cfw:open-org-calendar
  :config
  (setq cfw:fchar-junction ?╋
        cfw:fchar-vertical-line ?┃
        cfw:fchar-horizontal-line ?━
        cfw:fchar-left-junction ?┣
        cfw:fchar-right-junction ?┫
        cfw:fchar-top-junction ?┯
        cfw:fchar-top-left-corner ?┏
        cfw:fchar-top-right-corner ?┓)

  (use-package calfw-org
    :config
    (setq cfw:org-agenda-schedule-args '(:timestamp))))

(rune/leader-keys
  "cc"  '(cfw:open-org-calendar :which-key "calendar"))

(defun rune/suspend ()
    (interactive)
    (start-process-shell-command "suspend" nil "systemctl suspend"))

  (rune/leader-keys
    "o" '(rune/suspend :which-key "Suspend"))

(use-package cricbuzz)

(+ 50 100)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
	 '(zlc yasnippet yaml-mode which-key web-mode vterm visual-fill-column visual-fill use-package typescript-mode sx spotify speed-type spacemacs-theme smex skewer-mode scss-mode rustic rainbow-mode rainbow-delimiters racer python-mode pug-mode prettier-js pdf-tools ox-reveal org-wild-notifier org-tree-slide org-special-block-extras org-plus-contrib org-make-toc org-gcal org-bullets org-alert ob-dart monokai-theme lua-mode lsp-ui lsp-python-ms lsp-ivy lsp-dart lorem-ipsum jade-mode ivy-youtube ivy-rich ivy-pass impatient-mode hide-mode-line helpful google-translate git-gutter-fringe general forge flycheck fish-completion exwm exec-path-from-shell evil-smartparens evil-nerd-commenter evil-magit evil-collection eterm-256color eshell-toggle eshell-syntax-highlighting eshell-git-prompt esh-autosuggest emojify emmet-mode elcord doom-themes doom-modeline dired-single dired-sidebar dired-rainbow dired-open dired-hide-dotfiles dashboard darkroom cricbuzz counsel-spotify counsel-projectile counsel-osx-app company-tabnine company-racer company-box comment-tags command-log-mode cargo calfw-org calfw bufler autothemer autopair all-the-icons-dired afternoon-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dashboard-heading ((t (:foreground "#fff" :weight bold)))))
