;;; -*- lexical-binding: t; -*

(xterm-mouse-mode 1)
(setq mouse-drag-copy-region t)
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

(beacon-mode 1)
(colorful-mode 1)
(context-menu-mode 1)
(tool-bar-mode 1)
(menu-bar-mode 1)
;;(parrot-mode 1)
;;(nyan-mode 1)

(setq doom-theme 'doom-moonlight)
(setq zone-timer (run-with-idle-timer 120 t 'zone))

(defun theme-colors-setup ()
  "Setup Colors"
  (when (not (display-graphic-p))
    (set-face-background 'default "unspecified-bg" (selected-frame))
    (set-face-background 'fringe "unspecified-bg" (selected-frame))
    (set-face-background 'hl-line "steelblue4")
    (set-face-background 'region "steelblue4" (selected-frame))
    (set-face-background 'mode-line "unspecified-bg" (selected-frame))
    (set-face-background 'line-number "unspecified-bg" (selected-frame))
    (set-face-background 'line-number-current-line "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook #'theme-colors-setup)
(add-hook 'doom-load-theme-hook #'theme-colors-setup)

(after! doom-themes
  (custom-set-faces!
    '(popup-menu :background "#1e1e2e" :foreground "#cdd6f4")
    '(menu :background "unspecified-bg" :foreground "#cdd6f4")
    '(tty-menu-enabled-face :background "unspecified-bg" :foreground "mediumpurple1" :weight bold)
    '(tty-menu-disabled-face :background "unspecified-bg" :foreground "#575268" :weight normal)
    '(tty-menu-selected-face :background "steelblue4" :foreground "mediumpurple1" :weight bold)
    '(context-menu-region "unspecified-bg" :foreground "#f5c2e7" :weight bold)
    '(menu-bar :background "unspecified-bg" :foreground "#cdd6f4")))
