;; Require the Autothemer package
(require 'autothemer)

;; Name and description are completely your choice
(autothemer-deftheme
 custom "A Custom Theme made by Kavin Desi Valli"

((((class color) (min-colors #xFFFFFF)))
 (custom-dark      "#080b0f")
 ;; (custom-dark-100 "#1c1c1c")
 (custom-dark-100 "#101820")
 (custom-dark-200 "#8a8a8a")
 (custom-light      "#ffffff")
 (custom-black      "#000")
 (custom-light-blue "#64bced")
 (custom-light-blue-100 "#00d5ff")
 (custom-cyan       "#4DD0E1")
 (custom-dk-gray    "#757575")
 (custom-yellow  "#fee715")
 (custom-pink    "#ff6be9")
 (custom-orange  "#D7C49E")
 (custom-orange-100 "#ffaa00")
 (custom-pale-100 "#F2AA4C")
 (custom-red     "HotPink2")
 (custom-green   "LightGreen")
 )

((default (:foreground custom-light :background custom-dark))

(cursor (:background custom-light))

(font-lock-keyword-face (:foreground custom-light-blue))

;; This is what a comment looks like
(font-lock-comment-face (:foreground custom-dark-200))

(font-lock-string-face (:foreground custom-yellow))

(org-document-info-keyword (:foreground custom-dk-gray))

(org-meta-line (:foreground custom-cyan))

(org-level-1 (:foreground custom-pink))

(org-level-2 (:foreground custom-orange))

(org-verbatim (:foreground custom-green :background custom-black))

(org-block-begin-line (:background custom-dark-100 :foreground custom-pale-100))
(org-block (:background custom-dark-100))

)

)
