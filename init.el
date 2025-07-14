;; .emacs.d/init.el

;; ===================================
;; MELPA Package Support
;; ===================================

;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    material-theme                  ;; Theme
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)


;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)    ;; Hide the startup message
(load-theme 'material t)            ;; Load material theme
(global-linum-mode t)               ;; Enable line numbers globally


;; ===================================
;; My conventional preferences
;; ===================================


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ site-lisp                                                     ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "site-lisp" 'face '(:foreground "red")))

(let ( (default-directory
         (file-name-as-directory (concat user-emacs-directory "site-lisp")))
       )
  (add-to-list 'load-path default-directory)
  (normal-top-level-add-subdirs-to-load-path)
  )


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ language - coding system                                      ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "coding-system" 'face '(:foreground "red")))

;; デフォルトの文字コード
(set-default-coding-systems 'utf-8-unix)

;; テキストファイル／新規バッファの文字コード
(prefer-coding-system 'utf-8-unix)

;; ファイル名の文字コード
(set-file-name-coding-system 'utf-8-unix)

;; キーボード入力の文字コード
(set-keyboard-coding-system 'utf-8-unix)

;; サブプロセスのデフォルト文字コード
(setq default-process-coding-system '(undecided-dos . utf-8-unix))

;; 環境依存文字 文字化け対応
(set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
                      'katakana-jisx0201 'iso-8859-1 'cp1252 'unicode)
(set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ screen - buffer                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "buffer" 'face '(:foreground "red")))

;; バッファ画面外文字の切り詰め表示（有効：t、無効：nil）
(set-default 'truncate-lines t)

;; ウィンドウ縦分割時のバッファ画面外文字の切り詰め表示（有効：t、無効：nil）
(setq truncate-partial-width-windows nil)

;; 同一バッファ名にディレクトリ付与
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;; Do not display newline symbol at wrapping text.
(setf (cdr (assq 'continuation fringe-indicator-alist))
      '(nil nil) ;; no continuation indicators
      ;; '(nil right-curly-arrow) ;; right indicator only
      ;; '(left-curly-arrow nil) ;; left indicator only
      ;; '(left-curly-arrow right-curly-arrow) ;; default
      )

;; Change line wrap with a key bind
(define-key global-map (kbd "C-:") 'toggle-truncate-lines)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ screen - tabbar                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "tabbar" 'face '(:foreground "red")))

(require 'tabbar)

;; tabbar有効化（有効：t、無効：nil）
(call-interactively 'tabbar-mode t)

;; ボタン非表示
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil) (cons "" nil)))
  )

;; タブ切替にマウスホイールを使用（有効：0、無効：-1）
(call-interactively 'tabbar-mwheel-mode -1)
(remove-hook 'tabbar-mode-hook      'tabbar-mwheel-follow)
(remove-hook 'mouse-wheel-mode-hook 'tabbar-mwheel-follow)

;; タブグループを使用（有効：t、無効：nil）
(defvar tabbar-buffer-groups-function nil)
(setq tabbar-buffer-groups-function nil)

;; タブの表示間隔
(defvar tabbar-separator nil)
(setq tabbar-separator '(1.0))

;; タブ切り替え
(global-set-key (kbd "C-.") 'tabbar-forward-tab)
(global-set-key (kbd "C-,") 'tabbar-backward-tab)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ search - migemo                                               ;;;
;;;   https://github.com/emacs-jp/migemo                            ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "migemo" 'face '(:foreground "red")))

(autoload 'migemo-init "migemo" nil t)

(with-eval-after-load 'migemo
  (defvar migemo-command nil)
  (setq migemo-command "cmigemo")

  (defvar migemo-options nil)
  (setq migemo-options '("-q" "--emacs"))

  (defvar migemo-dictionary nil)
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")

  (defvar migemo-user-dictionary nil)

  (defvar migemo-regex-dictionary nil)

  (defvar migemo-coding-system nil)
  (setq migemo-coding-system 'utf-8-unix)
)

(add-hook 'emacs-startup-hook 'migemo-init)

(message "%s" (propertize "end of init.el" 'face '(:foreground "red")))


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ search - isearch                                              ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "isearch" 'face '(:foreground "red")))

;; 大文字・小文字を区別しないでサーチ（有効：t、無効：nil）
(setq-default case-fold-search nil)

;; インクリメント検索時に縦スクロールを有効化（有効：t、無効：nil）
(setq isearch-allow-scroll nil)

;; C-dで検索文字列を一文字削除
(define-key isearch-mode-map (kbd "C-d") 'isearch-delete-char)

;; C-yで検索文字列にヤンク貼り付け
(define-key isearch-mode-map (kbd "C-y") 'isearch-yank-kill)

;; C-eで検索文字列を編集
(define-key isearch-mode-map (kbd "C-e") 'isearch-edit-string)

;; Tabで検索文字列を補完
(define-key isearch-mode-map (kbd "TAB") 'isearch-yank-word)

;; C-gで検索を終了
(define-key isearch-mode-map (kbd "C-g")
  #'(lambda() (interactive) (isearch-done)))


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ file - backup                                                 ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "backup" 'face '(:foreground "red")))

;; ファイルオープン時のバックアップ（~）（有効：t、無効：nil）
(setq make-backup-files   t)  ;; 自動バックアップの実行有無
(setq version-control     t)  ;; バックアップファイルへの番号付与
(setq kept-new-versions   3)  ;; 最新バックアップファイルの保持数
(setq kept-old-versions   0)  ;; 最古バックアップファイルの保持数
(setq delete-old-versions t)  ;; バックアップファイル削除の実行有無

(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
            backup-directory-alist))

;; 編集中ファイルの自動バックアップ（有効：t、無効：nil）
(setq backup-inhibited nil)

;; 終了時に自動バックアップファイルを削除（有効：t、無効：nil）
(setq delete-auto-save-files nil)

;; 編集中ファイルのバックアップ（有効：t、無効：nil）
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)

;; 編集中ファイルのバックアップ間隔（秒）
(setq auto-save-timeout 3)

;; 編集中ファイルのバックアップ間隔（打鍵）
(setq auto-save-interval 100)

;; 編集中ファイル（##）の格納ディレクトリ
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/auto-save/") t)))


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ file - lockfile                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "lockfile" 'face '(:foreground "red")))

;; Make lockfiles (Enable: t, Dsiable: nil)
(setq create-lockfiles nil)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ scroll                                                        ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "scroll" 'face '(:foreground "red")))

;; スクロール時のカーソル位置を維持（有効：t、無効：nil）
(setq scroll-preserve-screen-position t)

;; スクロール開始の残り行数
(setq scroll-margin 0)

;; スクロール時の行数
(setq scroll-conservatively 10000)

;; スクロール時の行数（scroll-marginに影響せず）
(setq scroll-step 0)

;; 画面スクロール時の重複表示する行数
(setq next-screen-context-lines 1)

;; キー入力中の画面更新を抑止（有効：t、無効：nil）
(setq redisplay-dont-pause t)

;; recenter-top-bottomのポジション
(setq recenter-positions '(middle top bottom))

;; 横スクロール開始の残り列数
(setq hscroll-margin 1)

;; 横スクロール時の列数
(setq hscroll-step 1)

;; スクロールダウン
(global-set-key (kbd "C-z") 'scroll-down)

;; バッファの最後までスクロールダウン
(defadvice scroll-down (around scroll-down activate compile)
  (interactive)
  (let (
        (bgn-num (+ 1 (count-lines (point-min) (point))))
        )
    (if (< bgn-num (window-height))
        (goto-char (point-min))
      ad-do-it) ))

;; バッファの先頭までスクロールアップ
(defadvice scroll-up (around scroll-up activate compile)
  (interactive)
  (let (
        (bgn-num (+ 1 (count-lines (point-min) (point))))
        (end-num nil)
        )
    (save-excursion
      (goto-char (point-max))
      (setq end-num (+ 1 (count-lines (point-min) (point))))
      )
    (if (< (- (- end-num bgn-num) (window-height)) 0)
        (goto-char (point-max))
      ad-do-it) ))


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ flymake                                                       ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "flymake" 'face '(:foreground "red")))

(with-eval-after-load 'flymake

  ;; Appearance
  (add-hook 'flymake-mode-hook
            (lambda ()
              (set-face-attribute 'flymake-errline nil
                                  :underline "red"
                                  :weight 'bold
                                  :background nil)
              (set-face-attribute 'flymake-warnline nil
                                  :underline "yellow"
                                  :weight 'bold
                                  :background nil)
              ))

  ;; Move to warning/error lines with M-p/M-n
  (global-set-key "\M-p" 'flymake-goto-prev-error)
  (global-set-key "\M-n" 'flymake-goto-next-error)

  ;; Display warning/error lines
  (global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)

  ;; Don't display warnings in GUI
  (setq flymake-gui-warnings-enabled t)

  ;; Also apply syntax checks for header files
  (push '("\\.h\\'" flymake-simple-make-init flymake-master-cleanup)
        flymake-allowed-file-name-masks)

  ;; UNDER REVIEW START
  ;; ;; Show error in minibuffer
  ;; (defun flymake-show-help ()
  ;;   (when (get-char-property (point) 'flymake-overlay)
  ;;     (let ((help (get-char-property (point) 'help-echo)))
  ;;       (if help (message "%s" help)))))
  ;; (add-hook 'post-command-hook 'flymake-show-help)
  ;; UNDER REVIEW END
)

;; Enable/Disable flymake-mode by hand
(global-set-key (kbd "C-|") 'flymake-mode)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ xcscope                                                       ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "xcscope" 'face '(:foreground "red")))

(autoload 'cscope-minor-mode "xcscope" nil t)
(with-eval-after-load 'cscope

  (setq cscope-do-not-update-database t)

)

(add-hook 'c-mode-hook 'cscope-minor-mode)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ moccur                                                        ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "moccur" 'face '(:foreground "red")))

;; occur search by M-o
;; grep by M-x moccur-grep-find
;; Type 'r' in the grep result buffer to eneter the edit mode.
;; Save by C-x C-s.
;; Exit without save by C-x C-k.

;; For color-moccur
(global-set-key (kbd "M-o") 'occur-by-moccur)
(autoload 'occur-by-moccur "color-moccur" nil t)
(autoload 'moccur-grep "color-moccur" nil t)
(autoload 'moccur-grep-find-subdir "color-moccur" nil t)
(autoload 'moccur-grep-find "color-moccur" nil t)
(with-eval-after-load 'color-moccur
  (setq moccur-split-word t)
  (setq moccur-use-migemo t)
)

;; For moccur-edit
(autoload 'moccur-edit-mode-in "moccur-edit" nil t)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ gdb                                                           ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "gdb-mode" 'face '(:foreground "red")))

;; Open useful windows
(setq gdb-many-windows t)

;; Display the value of a variable at which the mouse cursor is being placed
(add-hook 'gdb-mode-hook #'(lambda () (gud-tooltip-mode t)))

;; Display I/O buffers to see standard input/output
(setq gdb-use-separate-io-buffer t)

;; Set 't' to this variable if you want values displayed on the mini buffer
(setq gud-tooltip-echo-area nil)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ c-mode                                                        ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "c-mode" 'face '(:foreground "red")))

;; My C mode
(add-hook
 'c-mode-hook
 #'(lambda()
     (c-set-style "K&R")
     (setq tab-width 8)
     (setq indent-tabs-mode nil)
     (setq c-basic-offset 8)
     (setq comment-start "//")
     (setq comment-end "")
     (hide-ifdef-mode t)
     (hide-ifdefs)
     ))

;;
;; Other c-mode to use M-x "xxxx-c-mode"
;;

;; stm32-c-mode
(defun stm32-c-mode ()
  "C mode with adjusted defaults for use with STM32 MCU drivers."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq indent-tabs-mode nil)
  (setq comment-start "//")
  (setq comment-end "")
)

;; gnu-c-mode
(defun gnu-c-mode ()
  "GNU C mode."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  ;; comment style
  (setq comment-start "/*")
  (setq comment-end "*/")
  )

;;
;; An example from "Linux Kernel Coding Rule"
;;

;; linux-c-mode
;; This will define the M-x linux-c-mode command.When hacking on a
;; module, if you put the string -*- linux-c -*- somewhere on the first
;; two lines, this mode will be automatically invoked.
(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8)
  )


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ c++-mode                                                      ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "c++-mode" 'face '(:foreground "red")))

(autoload 'google-set-c-style "google-c-style" nil t)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;;
;; Another setting
;;

;; (defun my-c++-mode-hook ()
;;   (setq indent-tabs-mode nil)
;;   (setq c-basic-offset 2)
;;   )
;; (add-hook 'c++-mode-hook 'my-c++-mode-hook)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ text-mode                                                     ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "text-mode" 'face '(:foreground "red")))

;; Wrap longer line automatically (disable by default)
(setq text-mode-hook 'turn-off-auto-fill)
(add-hook 'text-mode-hook
          #'(lambda()
             (progn (set-fill-column 70)
                    (turn-on-auto-fill))))

;; Enable/Disable auto-fill-mode by hand
(define-key global-map (kbd "C-;") 'auto-fill-mode)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ emacs-lisp-mode                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

;; Don't insert a tab character with the tab key in emacs-lisp-mode
(add-hook
 'emacs-lisp-mode-hook
 #'(lambda() (setq indent-tabs-mode nil))
 )


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ ld-mode                                                       ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "ld-mode" 'face '(:foreground "red")))

(defun ld-mode ()
  "GNU LD linker script mode."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq indent-tabs-mode nil)
  ;; comment style
  (setq comment-start "/*")
  (setq comment-end "*/")
  )


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ org-mode                                                      ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "org-mode" 'face '(:foreground "red")))

(autoload 'org-mode "org" nil t)
(add-hook 'org-mode-hook 'howm-mode)
(with-eval-after-load 'org
  (setq org-startup-folded 'showall)
  (setq org-src-fontify-natively t)
  (setq org-fontify-quote-and-verse-blocks t)

  ;; UNDER REVIEW START
  ;; (setq org-indent-mode-turns-on-hiding-stars nil)
  ;; (setq org-indent-indentation-per-level 3)
  ;; (add-hook 'org-mode-hook 'turn-off-auto-fill)
  ;; UNDER REVIEW END
)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ markdown-mode                                                 ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "markdown-mode" 'face '(:foreground "red")))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)

(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))

(add-hook 'markdown-mode-hook 'turn-off-auto-fill)

(with-eval-after-load 'markdown-mode
  (setq pandoc-cmd (concat "pandoc -s -c " (getenv "MKDWCSS")))
  (custom-set-variables
   '(markdown-command pandoc-cmd)
   '(markdown-fontify-code-blocks-natively t)
   '(markdown-header-scaling t)
   '(markdown-indent-on-enter 'indent-and-new-item))
  (define-key markdown-mode-map (kbd "<S-tab>") #'markdown-shifttab)
  )

;; UNDER REVIEW START
;; ;; Tune header colors
;; (progn
;;   (custom-set-faces
;;    '(markdown-header-delimiter-face ((t (:inherit org-mode-line-clock))))
;;    '(markdown-header-face-1 ((t (:inherit outline-1 :weight bold :height 1.3))))
;;    '(markdown-header-face-2 ((t (:inherit outline-2 :weight bold :height 1.2))))
;;    '(markdown-header-face-3 ((t (:inherit outline-3 :weight bold :height 1.1))))
;;    '(markdown-header-face-4 ((t (:inherit outline-4 :weight bold))))
;;    '(markdown-header-face-5 ((t (:inherit outline-5 :weight bold))))
;;    '(markdown-header-face-6 ((t (:inherit outline-6 :weight bold))))
;;    '(markdown-pre-face ((t (:inherit org-formula))))
;;    ))

;; ;; custom color
;; (defface markdown-header-face-1
;;   '((((class color) (background light))
;;      (:foreground "DeepPink1" :underline "DeepPink1" :weight bold))
;;     (((class color) (background dark))
;;      (:foreground "DeepPink1" :underline "DeepPink1" :weight bold)))
;;   "Face for level-1 headers.")

;; (defface markdown-header-face-2
;;   '((((class color) (background light))
;;      (:foreground "yellow1" :underline "yellow1" :weight bold))
;;     (((class color) (background dark))
;;      (:foreground "yellow1" :underline "yellow1" :weight bold)))
;;   "Face for level-2 headers.")

;; (defface markdown-header-face-3
;;   '((((class color) (background light))
;;      (:foreground "SlateBlue1" :underline "SlateBlue1" :weight bold))
;;     (((class color) (background dark))
;;      (:foreground "SlateBlue1" :underline "SlateBlue1" :weight bold)))
;;   "Face for level-3 headers.")

;; (defface markdown-header-face-4
;;   '((((class color) (background light))
;;      (:foreground "green" :underline "green" :weight bold))
;;     (((class color) (background dark))
;;      (:foreground "green" :underline "green" :weight bold)))
;;   "Face for level-4 headers.")

;; (defface markdown-header-face-5
;;   '((((class color) (background light))
;;      (:foreground "orange" :underline "orange" :weight bold))
;;     (((class color) (background dark))
;;      (:foreground "orange" :underline "orange" :weight bold)))
;;   "Face for level-5 headers.")

;; (defface markdown-header-face-6
;;   '((((class color) (background light))
;;      (:foreground "pink" :underline "pink" :weight bold))
;;     (((class color) (background dark))
;;      (:foreground "pink" :underline "pink" :weight bold)))
;;   "Face for level-6 headers.")
;; UNDER REVIEW END


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ sh-mode                                                       ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "sh-mode" 'face '(:foreground "red")))

(defun turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))
(add-hook 'sh-mode-hook #'turn-off-indent-tabs-mode)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ visual-basic-mode                                             ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "visual-basic-mode" 'face '(:foreground "red")))

(autoload 'vbnet-mode "vbnet-mode" "Mode for editing VB.NET code." t)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ auto-mode-alist                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "auto-mode-alist" 'face '(:foreground "red")))

;; select mode according to file extension
(setq auto-mode-alist
      (append
       '(
         ("\\.c$"    . c-mode)
         ("\\.h\\'"  . c-mode)
         ("\\.cpp$"  . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.hh$"   . c++-mode)
         ("\\.el$"   . emacs-lisp-mode)
         ("\\.ld$"   . ld-mode)
         ("\\.txt$"  . org-mode)
         ("\\.md$'"  . gfm-mode)
         ("\\.vb$"   . vbnet-mode)
         ("\\.vbs$"  . vbnet-mode)

         )
       auto-mode-alist))


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ text-adjust                                                   ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "text-adjust" 'face '(:foreground "red")))

(autoload 'text-adjust "text-adjust" nil t)
(with-eval-after-load 'text-adjust
  ;; 「？！」や全角空白を半角へ変換しないようにしたい
  (setq text-adjust-hankaku-except "　？！＠ー〜、，。．")
)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ imenu-list                                                    ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "imenu-list" 'face '(:foreground "red")))

(autoload 'imenu-list "imenu-list" nil t)
(with-eval-after-load 'imenu-list
  (define-key imenu-list-major-mode-map (kbd "j") 'next-line)
  (define-key imenu-list-major-mode-map (kbd "k") 'previous-line)
)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ redo                                                          ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "redo" 'face '(:foreground "red")))

(require 'redo+)
(define-key global-map (kbd "C-?") 'redo)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ grep-edit                                                     ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "grep-edit" 'face '(:foreground "red")))

;; C-c C-e : apply the highlighting changes to files.
;; C-c C-u : All changes are ignored
;; C-c C-r : Remove the highlight in the region (The Changes doesn't

(with-eval-after-load 'grep
  (require 'grep-edit)
  (defadvice grep-edit-change-file (around inhibit-read-only activate)
    ""
    (let ((inhibit-read-only t))
      ad-do-it)
    )
)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ restart-emacs                                                 ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "restart-emacs" 'face '(:foreground "red")))

(require 'restart-emacs)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ isearch-mode                                                  ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "isearch-mode" 'face '(:foreground "red")))

(add-hook 'isearch-mode-hook
            (function
             (lambda ()
               (define-key isearch-mode-map "\C-h" 'isearch-mode-help)
               (define-key isearch-mode-map "\C-t" 'isearch-toggle-regexp)
               (define-key isearch-mode-map "\C-c" 'isearch-toggle-case-fold)
               (define-key isearch-mode-map "\C-j" 'isearch-edit-string))))


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ insert-current-time
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "insert-current-time" 'face '(:foreground "red")))

(defun insert-current-time()
  (interactive)
  (insert (format-time-string "%Y-%m-%d(%a) %H:%M:%S" (current-time))))

(define-key global-map "\C-cd" `insert-current-time)


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ preferences                                                   ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(message "%s" (propertize "preferences" 'face '(:foreground "red")))

;; ;; Don't show splash screen after emacs booted
;; (setq inhibit-splash-screen t)

;; Inappropriate ioctl for device
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Start at "HOME" directory
;; (cd (getenv "HOME"))
;; (cd "~/")
(setq default-directory "~/")
(setq command-line-default-directory "~/")

;; Define system time locale
(setq system-time-locale "C")

;; Highlight corresponding parenthesis
(show-paren-mode t)

;; Quickly display key stroke at echo area
;(setq echo-keystrokes 0.1)

;; y instead of yes
(defalias 'yes-or-no-p 'y-or-n-p)

;; key bind for "goto-line"
(global-set-key "\M-g" 'goto-line)

;; Don't display grep: NUL: No such file or directory
(setq null-device "/dev/null")

;; ChangeLog header
(setq user-full-name "yago-hirokazu")
(setq user-mail-address "hyag16185@gmail.com")

;; Diplay full-width space, tab, space at the end of line
;; Dark themes
(defface my-face-b-1 '((t (:foreground "gray10" :underline t))) nil)
;; (defface my-face-b-1 '((t (:foreground "gray30" :underline t))) nil)
(defface my-face-b-2 '((t (:background "gray14"))) nil)

;; emacs-21
;; (defface my-face-b-2 '((t (:background "light cyan"))) nil)

;; Meadow
;; (defface my-face-b-1 '((t (:background "bisque"))) nil)
;; (defface my-face-b-2 '((t (:background "LemonChiffon2"))) nil)

(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; Sort buffers with names in Buffer-menu-mode
(setq Buffer-menu-sort-column 4)

;; Dont' show the initial message of the scratch buffer
(setq initial-scratch-message t)

;; Display the current time on the mode line
(display-time-mode 1)

;; Disable automatic indent
(electric-indent-mode -1)

;; Enable/Disable hide-ifdef-mode by hand
(setq-default hide-ifdef-initially nil)
(global-set-key (kbd "C-^") 'hide-ifdef-mode)


(message "%s" (propertize "end of init.el" 'face '(:foreground "red")))


;; User-Defined init.el ends here
