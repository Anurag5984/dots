;; oooooooooooo
;;  888'     `8
;;  888         ooo. .oo.  .oo.    .oooo.    .ooooo.   .oooo.o
;;  888oooo8    `888P"Y88bP"Y88b  `P   88b  d88' `"Y8 d88(  "8
;;  888    "     888   888   888   .oP"888  888       `"Y88b.
;;  888       o  888   888   888  d8(  888  888   .o8 o.  )88b
;; o888ooooood8 o888o o888o o888o `Y888""8o  Y8bod8P' 8""888P'

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(setq user-full-name "Anurag Pandey"
      user-mail-address "anuragp.5984@gmail.com")

(setq doom-theme 'doom-dracula
      doom-font (font-spec :family "MesloLGS Nerd Font" :size 22)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono NF" :size 23))

;; set transparency
(set-frame-parameter (selected-frame) 'alpha '(90 90))
(setq default-frame-alist
      (append '((alpha 85 85)
                (undecorated . t))
              default-frame-alist))

;; (after! doom-themes
;;   (setq doom-themes-enable-bold t
;;         doom-themes-enable-italic t))
;; (custom-set-faces!
;;   '(font-lock-comment-face :slant italic)
;;   '(font-lock-keyword-face :slant italic))


(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")

;; (use-package! lsp-tailwindcsr)

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.3))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.1))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.1))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
)

;; (after! org
;;   (setq
;;         org-ellipsis " ▼ "
;;         org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
;;         org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
;;         org-log-done 'time
;;         org-hide-emphasis-markers t))

(map! :leader
      :desc "Toggle vterm"
      "t t" #'+vterm/toggle
      :desc "Save and kill buffer"
      "w q" #'doom/save-and-kill-this-buffer
      :desc "Toggle comment"
      "/" #'comment-or-uncomment-region
      :desc "Close buffer"
      "x" #'kill-this-buffer
      :desc "Save buffer"
      "w w" #'save-buffer)

(defun doom/save-and-kill-this-buffer ()
  "Save the current buffer and close it."
  (interactive)
  (save-buffer)
  (kill-current-buffer))

