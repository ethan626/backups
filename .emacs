;;;;;;;; This is my .emacs ;;;;;;;;;;

(set-frame-font "Source code pro medium")


;;;;;;;;;;;;;;; JDEE - Java ;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/jdee")

					;(require 'jdee)
;;;;;;;;;;;;;;;;;;;;;;;;; Key Chord ;;;;;;;;;;;;;;;;;;;;
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define-global "jk" 'evil-normal-state)
(key-chord-define-global "sb" 'ido-switch-buffer)
(key-chord-define-global "ow" 'other-window)
(key-chord-define-global "vs" 'split-window-vertically)
(key-chord-define-global "hs" 'split-window-horizontally)
(key-chord-define-global "0s" 'delete-other-windows)
(key-chord-define-global "de" 'open-dot-emacs)
(key-chord-define-global "gs" 'goto-scratch)
;;; Evil Mode ;;;

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode)
;;; ESS ;;;;

(require 'ess-site)

;;;;;;;;;;; Python Mode ;;;;;;;;;;;;;;;;;;;
;;(setf python-shell-interpreter "python2.7")
(setf python-shell-interpreter "python")

(defun switch-python-shell ()
  "Switches the default Python shell from 2.7 to 3 and back"
  (interactive)
  (cond ((cl-equalp python-shell-interpreter "python2.7")
	 (setf python-shell-interpreter "python") (print "Switched Python shell to Python 3"))
	((cl-equalp python-shell-interpreter "python")
	 (setf python-shell-interpreter "python2.7") (print "Switched Python shell to Python 2.7"))))

;;;;;;;;;;;;;;; Startup Scratch Message ;;;;;;;;;;;;;;
(setf initial-scratch-message (animate-string ";; Hello Ethan, welcome to Emacs. This is the scratch buffer" 0 0))

;;;;;;;; Command Settings ;;;;;;;;;;
(put 'downcase-region 'disabled nil)

;;;;;;;;;;;; Variable Declarations ;;;;;;;;;;;

(setq disabled-command-function nil)	
(setq disabled-command-hook nil)
(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "/bin/conkeror")
(setq inhibit-startup-message t) ;;no GNU screen at startup 
(setq sentence-end-double-space nil);sentence ends in one space
(setq *time-until-change-colors* 2.5) ;in seconds
(setq *counter-for-change-colors* 0)
(setq *list-of-colors* (list  "purple" "grey" "orange" "maroon" "red" "green" "cyan" "maroon" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "skyblue" "gray50" "cyan"))

;;;;;;;; Macros ;;;;;;;;;;;;

(defmacro inter-func (name &body bod)
  "Returns a new interactive function named name"
  `(defun ,name ()
     (interactive)
     ,@bod))

(defmacro gsk (bind command)
  "Global set key"
  `(global-set-key (kbd ,bind) (quote ,command)))

;;;;;;;; Functions ;;;;;;;;;;;;

(defun insert-apostrophe()
  "Inserts an appostrophe as the second to last char in the word before point, cursor will stay at current point. Ex Ethans -> Ethan's"
  (interactive)
  (let ((cursor-pos (+ 1 (point))))
    (backward-word)
    (forward-word)
    (backward-char)
    (insert-char 39)    
    (goto-char cursor-pos)))

(defun single-quote-word ()
  "Wraps the word behind the cursor in single quotes"
  (interactive)
  (let ((cursor-pos (+ 1 (point))))
    (backward-word)
    (insert-char 39)    
    (forward-word)
    (insert-char 39)    
    (goto-char cursor-pos)))


(defun single-quote-region ()
 (interactive)
 (insert "\'")
 (exchange-point-and-mark)
 (insert "\'"))

(defun double-quote-region ()
 (interactive)
 (insert "\"")
 (exchange-point-and-mark)
 (insert "\""))

(defun double-quote-word ()
  "Wraps the word behind the cursor in single quotes"
  (interactive)
  (let ((cursor-pos (+ 1 (point))))
    (backward-word)
    (insert "\"")    
    (forward-word)
    (insert "\"")    
    (goto-char cursor-pos)))

(defun insert-apostrophe-and-capitalize()
  "Inserts an apostophe and capitalizes the word before the point"
  (interactive)
  (capitalize-word -1)
  (insert-apostrophe))

(defun make-possessive ()
  ""
  (interactive)
  (let ((cursor-pos (+ 2 (point))))
  (backward-word)
  (forward-word)
  (insert-char 39)
  (insert-char 115)
  (goto-char cursor-pos)))

(defun make-possessive-and-capitalize ()
  ""
  (interactive)
  (let ((cursor-pos (+ 2 (point))))
    (capitalize-word -1)
    (backward-word)
    (forward-word)
    (insert-char 39)
    (insert-char 115)  
    (goto-char cursor-pos)))

(defun comma-to-new-sentence ()
  "Changes a comma to a period after you have started the next sentence. Call from the end of the first word of the new sentence"
  (interactive)
  (backward-word 2)
  (forward-word)
  (delete-char 1)
  (insert-char 46)
  (capitalize-word 1))
  
(defun kill-junk-buffers ()		;rewrite with tagbodys to combat error with non-existent buffers
  (interactive)
  (cl-loop for i in '("*Buffer List*" "*Backtrace*" "*Messages*" "*Help*" "*Completions*") do
	   (if i			
	       (kill-buffer i))))

(defun mocp-next ()
  "Tells mocp to go to the next song"
  (interactive)
  (shell-command "mocp --next"))

(defun mocp-info ()
  "Gets the info on the currently playing song on the moc server"
  (interactive)
  (shell-command "mocp -i"))

(defun mocp-prev ()
  "Tells mocp to go to the previous song"
  (interactive)
  (shell-command "mocp --previous"))

(defun mocp-toggle ()
  "Toggles Play/Pause for moc"
  (interactive)
  (shell-command "mocp -G"))

(defun vol-down ()
  "Turns alsa Master down"
  (interactive)
  (shell-command "amixer set Master 5%- -q"))

(defun vol-up ()
  "Turns alsa master up"
  (interactive)
  (shell-command "amixer set Master 5%+ -q"))


(defmacro defopen-buffer (name file-name &optional docstring)
  `(defun ,name ()
     ,docstring
     (interactive)
     (setq *previous-buffer* (current-buffer))
     (find-file ,file-name)))
       

(defopen-buffer open-stumpwmrc "~/.stumpwmrc" "Opens my stumpwmrc for editing")
  
(defun open-dot-emacs ()
  "Opens ~/.emacs for editing"
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (find-file "~/.emacs"))

(defun goto-prev ()
  (interactive)
  (mode-line-other-buffer))

(defun goto-scratch ()
  "Switches to the scratch buffer"
  (interactive)  
  (switch-to-buffer "*scratch*"))

(defun goto-stock ()
  "Switches to the scratch buffer"
  (interactive)  
  (find-file "~/school/research/stock.py"))

(defun goto-inferior-lisp ()
  "Switches to the inferior-lisp buffer"
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (switch-to-buffer "*inferior-lisp*"))

(defun goto-python ()
  "Switches to the scratch buffer"
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (switch-to-buffer "*Python*"))

(defun goto-conkerorrc ()
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (find-file "~/.conkerorrc"))

(defun open-goof-off ()
  "Opens the goof off file"
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (find-file "~/programming/from-gentoo/lisp/lisp/goof-off.lisp"))

(defun open-magic-square ()
  "Opens the magick-squares project"
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (find-file "~/programming/from-gentoo/lisp/lisp/magic-square.lisp"))

(defun open-ethan ()
  "Opens ~/.emacs for editing"
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (find-file "~/programming/from-gentoo/lisp/lisp/ethan.lisp"))

(defun open-ethan-package()
  "Opens ~/.emacs for editing"
  (interactive)
  (setq *previous-buffer* (current-buffer))
  (find-file "~/programming/from-gentoo/lisp/lisp/ethan-package.lisp"))

(defun set-recall-point1 ()
  "Sets the variable recall-point1 to POINT"
  (interactive)
  (setq recall-point1 (point))
  (setq recall-buffer1 (current-buffer)))

(defun set-recall-point2 ()
  "Sets the variable recall-point2 to POINT"
  (interactive)
  (setq recall-point2 (point))
  (setq recall-buffer2 (current-buffer)))

(defun recall-to-point1 ()
  "Recalls to recall-point1"
  (interactive)
  (switch-to-buffer recall-buffer1)
  (goto-char recall-point1))

(defun recall-to-point2 ()
  "Recalls to recall-point2"
  (interactive)
  (switch-to-buffer recall-buffer2)
  (goto-char recall-point2))

(defun select-current-line ()
  "Select the current line" 
  (interactive)
  (end-of-line)
  (set-mark (point))
  (beginning-of-line))

(defun kill-all-buffers-except-scratch ()
  "Kill all buffers except scratch, used for emacs ocd and keeping the bufferlist tidy" 
  (interactive)
  (cl-loop for buff in (buffer-list) do (save-some-buffers))
  (cl-loop for buf in (buffer-list) do
	   (cond ((not (cl-equalp buf '*scratch*)) (kill-buffer)))))

(defun capitalize-word-behind-cursor ()
  "Identical to (capitalize-word -1)" 
  (interactive)		       
  (capitalize-word -1))

(defun change-colors ()
  (interactive)
  (set-foreground-color (nth *counter-for-change-colors* *list-of-colors*))
  (setq *counter-for-change-colors* (+ 1 *counter-for-change-colors*))
  (when (<= (length *list-of-colors*)  *counter-for-change-colors*)
    (setq *counter-for-change-colors* 0)))

(defun activate-change-colors ()
  (interactive)
  (setq *activate-change-color-timer* (run-with-timer 0 *time-until-change-colors* 'change-colors)))

(defun deactiveate-change-colors ()
  (interactive)
  (cancel-timer *activate-change-color-timer*)
  (set-foreground-color "cyan"))

(defun speed-up-color-change ()
  (interactive)
  (cond ((< 1 *time-until-change-colors*) (setq *time-until-change-colors* (- *time-until-change-colors* 1)))))
(defun slow-down-color-change ()
  (interactive)
  (setq *time-until-change-colors* (+ 1 *time-until-change-colors*)))

;;;;;;;;;;;; Hooks ;;;;;;;;;;
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'slime-mode-hook 'slime)
(add-hook 'image-mode-hook 'eimp-mode)
(add-hook 'pdf-view-mode-hook 'pdf-tools-install)
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-tools-install))

;;;;;; SLIME/SWANK ;;;;;;

;;(setq inferior-lisp-program "/usr/bin/sbcl")
(setq inferior-lisp-program "/usr/bin/clisp")

;;;;;;; Load Path ;;;;;;;;
(add-to-list 'load-path "~/programming/from-gentoo/lisp/lisp/ethan.lisp")
(add-to-list 'load-path "~/emacs.d")
(add-to-list 'load-path "/usr/bin/")
(add-to-list 'load-path "~/.bashrc")
;; (load "/usr/share/emacs/site-lisp/haskell-mode/haskell-mode.el")
(autoload 'eimp-mode "eimp" "Emacs Image Manipulation Package." )

;;;;;;;;;;;; Default Modes ;;;;;;;;;;;;;
(ido-mode t) 				;changes a few default keybindings
(global-prettify-symbols-mode 1)
(transient-mark-mode 1)

;;;;;;;;;;;;; Media ;;;;;;;;;;;;;;;;;;;;

;; (add-to-list 'load-path "~/elisp/emms/")

;; (require 'emms-setup)
;; (emms-standard)
;; (emms-default-players)

;;;; New Prefix ;;;
(define-prefix-command 'cont-v-map)
(define-prefix-command 'meta-map)

;;;;;;;;;;;;; Keybindings ;;;;;;;;;;;;;;;
(global-set-key (kbd "C-v") 'cont-v-map) ;assigns C-v as a new prefix
;;;; C-u M-! - insert shell command
(gsk "C-v q" single-quote-word)
(gsk "C-v Q" double-quote-word)
(gsk "C-c \'" single-quote-region)
(gsk "C-c \"" double-quote-region)
(gsk "C-v o" make-possessive)
(gsk "C-v O" make-possessive-and-capitalize)
(gsk "C-v n" comma-to-new-sentence)
(gsk "C-v i" insert-apostrophe)
(gsk "C-v I" insert-apostrophe-and-capitalize)
(gsk "C-v j" join-line)
(gsk "C-z" delete-other-windows)
(gsk "C-x e" end-of-visual-line)
(gsk "C-v C-e" open-stumpwmrc)
(gsk "C-," scroll-down-command)
(gsk "C-." scroll-up-command)
(gsk "C-v C-s" ansi-term)
(gsk "C-v w" webjump)
(gsk "C-v p" goto-python)
(gsk "C-v l" goto-previous)
(gsk "C-v C-SPC" rectangle-mark-mode)
(global-set-key (kbd "C-v k") 'kill-junk-buffers)
(global-set-key (kbd "C-v c") 'goto-conkerorrc)
(global-set-key (kbd "C-v s") 'goto-scratch)
(global-set-key (kbd "C-v e") 'open-dot-emacs)
(global-set-key (kbd "C-v SPC") 'yank)
(global-set-key (kbd "C-x SPC") 'kill-region)
(global-set-key (kbd "C-c r") 'rename-buffer)
(global-set-key (kbd "C-x p") 'check-parens)
;; (global-set-key (kbd "C-x C-a") 'slime-eval-buffer)
(global-set-key (kbd "C-c a") 'ansi-term)
(global-set-key (kbd "C-c b") 'set-recall-point1)
(global-set-key (kbd "C-c B") 'recall-to-point1)
(global-set-key (kbd "C-c u") 'set-recall-point2)
(global-set-key (kbd "C-c U") 'recall-to-point2)
(global-set-key (kbd "C-c SPC") 'kill-ring-save)
(global-set-key (kbd "C-c a") 'apropos)
;; (global-set-key (kbd "C-u") 'undo)
(global-set-key (kbd "C-;") 'kill-ring-save)
(global-set-key (kbd "C-c n") 'new-frame)
(global-set-key (kbd "C-c e") 'end-of-buffer)
(global-set-key (kbd "C-c t") 'set-foreground-color)
(global-set-key (kbd "C-c x") 'kill-ring-save)
(global-set-key (kbd "C-c w") 'flyspell-correct-word-before-point) ;flyspell check 
(global-set-key (kbd "C-c c") 'flyspell-auto-correct-word)
(global-set-key (kbd "C-c f") 'flyspell-mode) ;turns on flyspell mode
(global-set-key (kbd "C-c i") 'indent-region) 
(global-set-key (kbd "C-x r") 'replace-string)
(global-set-key (kbd "C-x g") 'grep)
(global-set-key (kbd "C-q") 'kill-this-buffer)
(global-set-key (kbd "C-c s") 'shell-command)
(global-set-key (kbd "M-s b") 'search-keybind) ;also C-h a
(global-set-key (kbd "C-c j") 'goto-line)
(global-set-key (kbd "C-c w") 'Spell-Check-word)
(global-set-key (kbd "C-c k") 'activate-change-colors)
(global-set-key (kbd "C-c K") 'deactiveate-change-colors)
(global-set-key (kbd "C-c C-p") 'mark-paragraph)
(global-set-key (kbd "s-1") 'delete-other-windows)
(global-set-key (kbd "s-2") 'split-window-below)
(global-set-key (kbd "s-q") 'delete-window)
(global-set-key (kbd "s-a") 'other-window)
(global-set-key (kbd "s-3") 'split-window-vertically)
(global-set-key (kbd "s-<up>") 'shrink-window)
(global-set-key (kbd "s-<down>") 'enlarge-window)
(global-set-key (kbd "s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<up>") 'vol-up)
(global-set-key (kbd "M-<down>") 'vol-down)
(global-set-key (kbd "C-c p") 'mocp-toggle)
(global-set-key (kbd "M-<right>") 'mocp-next)
(global-set-key (kbd "M-<left>") 'mocp-prev)

;;;;;;;;;;;;;;;;;;;; evil mode ;;;;;;;;;;;;;;;;;;;
(define-key evil-insert-state-map (kbd "C-c p") 'goto-python)
(define-key evil-normal-state-map (kbd "C-c p") 'goto-python)
(define-key evil-insert-state-map (kbd "M-SPC") 'evil-force-normal-state)
(define-key evil-normal-state-map (kbd "M-SPC") 'evil-insert)
(define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
(define-key evil-insert-state-map "\C-e" 'end-of-line)
(define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
(define-key evil-motion-state-map "\C-e" 'evil-end-of-line)

(define-key evil-insert-state-map "\C-n" 'evil-next-line) 
(define-key evil-normal-state-map "\C-n" 'evil-next-line) 
(define-key evil-normal-state-map "\C-p" 'evil-previous-line)
(define-key evil-insert-state-map "\C-p" 'evil-previous-line)
(define-key evil-visual-state-map "\C-p" 'evil-previous-line)
(define-key evil-normal-state-map "fw" 'flyspell-auto-correct-word)
(define-key evil-normal-state-map "fe" 'flyspell-correct-word-before-point)
(define-key evil-normal-state-map "\C-a" 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map "\C-x" 'evil-numbers/dec-at-pt)
(define-key evil-normal-state-map " 'evil-numbers/dec-at-pt)

; (define-key evil-normal-state-map "vv" 'split-window-vertically)
;; (define-key evil-normal-state-map "VV" 'split-window-horizontally)
;; (define-key evil-normal-state-map "vc" 'delete-other-windows)
;; (define-key evil-normal-state-map "vb" 'ido-switch-buffer)
;; (define-key evil-normal-state-map "vu" 'other-window)


;;;;;;;; misc/unsorted ;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red" "cyan" "cyan" "cyan" "magenta3" "deepskyblue" "black"])
 '(custom-enabled-themes (quote (ahungry)))
 '(custom-safe-themes
   (quote
    ("dfe0523e20114df987a41afb6ac5698307e65e0fcb9bff12dc94621e18d44c3d" default)))
 '(doc-view-continuous t)
 '(initial-scratch-message
   ";; this buffer is for notes you don't want to save, and for lisp evaluation.
;; if you want to create a file, visit that file with c-x c-f,
;; then enter the text in that file's own buffer.

")
 '(package-selected-packages
   (quote
    (ahungry-theme evil-nerd-commenter evil-space evil-visualstar evil-numbers elfeed wanderlust ## cython-mode evil package-build shut-up epl git commander f s cask jdee pdf-tools eimp virtualenv jedi-core haskell-mode el-get djvu auctex ace-popup-menu ace-flyspell ac-slime ac-math ac-html-csswatcher ac-html ac-cider)))
 '(send-mail-function (quote mailclient-send-it))
 '(tex-view-program-list (quote (("mupdf" ("mupdf f") ""))))
 '(tex-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "pdf tools")
     (output-html "xdg-open"))))
 '(virtualenv-root "~/.virtualenvs/"))

;;removed dash because it was causing an error from package-build

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; (if window-system (require 'font-latex)
;;   (setq font-lock-maximum-decoration))

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   )
  (package-initialize))



;;;;;;;;;;;;;;; Webjumps ;;;;;;;;;;;;;;;;;;;;;;

(require 'webjump)
(setq webjump-sites
      (append '(("cwu" . "www.cwu.edu")
		("canvas" . "https://canvas.cwu.edu")
		("discogs" . "www.discogs.com")
		("youtube" .  "www.youtube.com")
		("amazon" . "www.amazon.com")
		("lisp documentation" . "http://www.lispworks.com/documentation/HyperSpec/Front/X_Master.htm"))
	      webjump-sample-sites))

(set-foreground-color "cyan")
(set-cursor-color "cyan")
;;;;;;;;;;;;; UNUSED ;;;;;;;;;;;;

;always have spell check
;(require 'flyspell)
;auto-load spell check for .tex
;(add-to-list 'auto-mode-alist '("\\.tex\\'" .latex-mode))
;(add-to-list 'auto-mode-alist '("\\.tex\\'" . flyspell-mode))

;;;;;;;;; end .emacs ;;;;;;

;; ;; In my case /path/to/quicklisp is ~/quicklisp
;; (defvar quicklisp-path "/path/to/quicklisp")
;; ;;
;; ;; Load slime-helper, this sets up various autoloads:
;; ;;
;; (load (concat quicklisp-path "/slime-helper"))
;; ;;
;; ;; Set up slime with whatever modules you decide to use:
;; ;;
;; (slime-setup '(slime-fancy slime-mrepl slime-banner slime-tramp
;; 	       slime-xref-browser slime-highlight-edits
;; 	       slime-sprof))
;; ;;
;; ;; Decide where to put a slime scratch file, if you want one, and set
;; ;; it up with:
;; ;;
;; (setf slime-scratch-file "/ethan/ethan/slime-scratch")
;; ;;
;; ;; Unfortunately there is no hook for the slime-scratch mode so if you
;; ;; want to automatically enable/disable various minor modes in the
;; ;; slime scratch buffer you must do something like:
;; ;;
;; (defadvice slime-scratch
;;     (after slime-scratch-adjust-modes () activate compile)
;;   (turn-some-mode-off)
;;   (turn-some-other-mode-on))

;;;;;;;;;;;;; Looks ;;;;;;;;;;;;;;;;;;;
(set-face-background 'region "cyan")
(set-foreground-color "cyan")
(set-cursor-color "cyan")
(set-background-color "black")
