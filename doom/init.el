;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

;; ============================================================
;; Doom 模組配置
;; ============================================================

;; 修改模組配置後執行 `doom sync`。

(doom! :input

       :completion
       (corfu +orderless)  ; 現代補全選單與模糊匹配
       vertico             ; 垂直補全選單

       :ui
       doom                ; Doom 核心外觀
       dashboard           ; 啟動畫面
       hl-todo             ; TODO/FIXME 高亮
       modeline            ; 狀態欄
       ophints             ; 操作提示
       (popup +defaults)   ; 彈出視窗
       (vc-gutter +pretty) ; Git 修改標記
       vi-tilde-fringe     ; 文件末尾標記
       workspaces          ; 工作區

       :editor
       file-templates      ; 文件模板
       fold                ; 代碼折疊
       snippets            ; 代碼片段
       (whitespace +guess +trim) ; 空白處理

       :emacs
       dired               ; 文件管理
       electric            ; 智能縮進
       tramp               ; 遠程文件編輯
       undo                ; 撤銷
       vc                  ; 版本控制

       :term

       :checkers
       syntax              ; 語法檢查

       :tools
       (eval +overlay)     ; 代碼執行
       lookup              ; 符號查找
       lsp                 ; LSP 語言服務器
       magit               ; Git 客戶端
       tree-sitter         ; 語法樹解析

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       (cc +lsp)           ; C / C++ LSP
       ;; (c3 +lsp)         ; C3 LSP：官方模組支持後啟用
       (rust +lsp)         ; Rust LSP
       (swift +lsp)        ; Swift LSP
       (lua +lsp)          ; Lua LSP
       (zig +lsp)          ; Zig LSP
       (csharp +lsp)       ; C# LSP
       (go +lsp)           ; Go LSP
       (python +lsp)       ; Python LSP
       (java +lsp)         ; Java LSP
       (kotlin +lsp)       ; Kotlin LSP
       (web +lsp)          ; Web LSP
       (haskell +lsp)      ; Haskell LSP
       (php +lsp)          ; PHP LSP

       emacs-lisp           ; Emacs Lisp
       markdown             ; Markdown
       org                  ; Org-mode
       sh                   ; Shell

       :email
       :app

       :config
       (default +bindings +smartparens))
