;;;;;;;;; This is my .emacs ;;;;;;;;;;

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

;;;;;;;;;;;;; Looks ;;;;;;;;;;;;;;;;;;;
(set-face-background 'region "cyan")

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
(gsk "C-z" delete-other-windows)
(gsk "C-x e" end-of-visual-line)
(global-set-key (kbd "C-v") 'cont-v-map) ;assigns C-v as a new prefix
(gsk "C-," scroll-down-command)
(gsk "C-." scroll-up-command)
(gsk "C-v C-s" ansi-term)
(gsk "C-v w" webjump)
(gsk "C-v p" goto-python)
(gsk "C-v l" goto-previous)
(gsk "C-v r" goto-stock)
(global-set-key (kbd "C-v i") 'goto-inferior-lisp)
(global-set-key (kbd "C-v k") 'kill-junk-buffers)
(global-set-key (kbd "C-v m") 'open-magic-square)
(global-set-key (kbd "C-v c") 'goto-conkerorrc)
(global-set-key (kbd "C-v s") 'goto-scratch)
(global-set-key (kbd "C-v e") 'open-dot-emacs)
(global-set-key (kbd "C-v SPC") 'yank)
(global-set-key (kbd "C-x SPC") 'kill-region)
(global-set-key (kbd "C-c r") 'rename-buffer)
(global-set-key (kbd "C-x p") 'check-parens)
(global-set-key (kbd "C-x C-a") 'slime-eval-buffer)
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

;;;;;;;; Misc/Unsorted ;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-list (quote (("mupdf" ("mupdf f") ""))))
 '(TeX-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "PDF Tools")
     (output-html "xdg-open"))))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(doc-view-continuous t)
 '(initial-scratch-message
   ";; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

")
 '(package-selected-packages
   (quote
    (pdf-tools eimp virtualenv jedi-core haskell-mode el-get djvu auctex ace-popup-menu ace-flyspell ac-slime ac-math ac-html-csswatcher ac-html ac-cider)))
 '(send-mail-function (quote mailclient-send-it))
 '(virtualenv-root "~/.virtualenvs/"))

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

;;;;;;;;; Aesthetics ;;;;;;;;;;
(set-foreground-color "cyan")
(set-cursor-color "cyan")

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

