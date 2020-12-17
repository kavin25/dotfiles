(when (equal system-name "kavin-pc")
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))

  (add-hook 'exwm-update-title-hook
            (lambda ()
              (pcase exwm-class-name
                ("qutebrowser" (exwm-workspace-rename-buffer (format "Qutebrowser: %s" exwm-title))))))

        (defun rune/move-buffer-to-workspace ()
          (interactive)
          (pcase exwm-class-name
            ("qutebrowser" (exwm-workspace-move-window 1))
            ("discord" (exwm-workspace-move-window 2))))

        (defun rune/run-in-background (command)
          (let ((command-parts (split-string command "[ ]+")))
            (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

      (defun rune/set-wallpaper ()
        (interactive)
        (start-process-shell-command
         "feh" nil "feh --bg-scale /home/netree/backgrounds/mountains.jpg"))

      (defun rune/exwm-init-hook ()
        ;; Make workspace 0 be the one where we land on startup
        (exwm-workspace-switch-create 0)

        (start-process-shell-command "discord" nil "discord")
        (start-process-shell-command "qutebrowser" nil "~/qutebrowser/.venv/bin/python3.8 -m qutebrowser")

        (display-battery-mode 1)

        (setq display-time-day-and-date t)
          (display-time-mode 1)


        (rune/run-in-background "nm-applet")
        (rune/run-in-background "pasystray")
        (rune/run-in-background "blueman-applet"))

      (add-hook 'exwm-manage-finish-hook
                (lambda ()
                  ;; Send the window where it belongs
                  (rune/move-buffer-to-workspace)))

      (use-package exwm
        :config
        (setq exwm-workspace-number 5)

        ;; Rebind Caps lock to control
        (start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")

        ;; When exwm starts up do some extra configuration
        (add-hook 'exwm-init-hook #'rune/exwm-init-hook)

        (require 'exwm-randr)
        (exwm-randr-enable)
        (start-process-shell-command "xrandr" nil "xrandr --output VIRTUAL1 --off --output DP3 --off --output DP2 --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output HDMI3 --off --output HDMI2 --off --output HDMI1 --off")

        (rune/set-wallpaper)


        (require 'exwm-systemtray)
        (setq exwm-systemtray-height 32)
        (exwm-systemtray-enable)

        (setq exwm-input-prefix-keys
              '(?\C-x
                ?\C-u
                ?\C-h
               ?\M-x
               ?\M-`
               ?\M-:
               ?\M-&
               ?\C-\M-j
               ?\C-\ ))

        (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

        (setq exwm-input-global-keys
              `(
                 ([?\s-r] . exwm-reset)
                 ([s-left] . windmove-left)
                 ([s-right] . windmove-right)
                 ([s-up] . windmove-up)
                 ([s-down] . windmove-down)
                 ;; Launch applications via shell commands
                 ([?\s-&] . (lambda (command)
                              (interactive (list (read-shell-command "$ ")))
                              (start-process-shell-command command nil command)))
                 ;; Switch Workspace
                 ([?\s-w] . exwm-workspace-switch)
                 ([?\s-`] . (lambda () (interactive)
                              (exwm-workspace-switch-create 0)))

                 ,@(mapcar (lambda (i)
                           `(,(kbd (format "s-%d" i)) .
                             (lambda ()
                               (interactive)
                               (exwm-workspace-switch-create ,i))))
                           (number-sequence 0 9))))

        (exwm-input-set-key (kbd "s-SPC") 'counsel-linux-app)
        (exwm-enable))
      )

(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-"))
