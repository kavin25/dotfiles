(require 'autothemer)

(autothemer-deftheme
 hallo "A theme to set the mood for halloween"

 ((((class color) (min-colors #xFFFFFF)))

	;; Define colour pallete
	(hallo-black "#000000")
	(hallo-white "#ffffff")
	(hallo-dk-orange "#eb6123")
	(hallo-purple    "MediumPurple2")
	(hallo-dk-purple    "MediumPurple4")
	(hallo-green     "LightGreen")
	(hallo-orange     "orange1")
	)
 
 ((default                     (:foreground hallo-white :background hallo-black))
	(cursor                      (:background hallo-dk-orange))
	(region                      (:background hallo-dk-purple))
	(font-lock-keyword-face      (:foreground hallo-purple))
	(font-lock-constant-face      (:foreground hallo-green))
	(font-lock-string-face      (:foreground hallo-orange))
	(org-level-1      (:foreground hallo-orange))
	))

(provide-theme 'hallo)
