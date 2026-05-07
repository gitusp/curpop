# cursor-highlighter

画面共有中にマウスカーソル位置を目立たせるための macOS 用ユーティリティ。ホットキー一発で、現在のカーソル位置に円形のハイライトを表示してフェードアウトする。

## 構成

- `highlight.swift` — 起動するとカーソル位置に円を描画し、約 1.1 秒後に終了する単発バイナリのソース
- `Makefile` — ビルド／インストール
- `karabiner/cursor-highlight.json` — Karabiner-Elements の Complex Modifications 用設定（右Command単押しでハイライト）

## ビルドとインストール

```bash
make install            # ~/.local/bin/highlight にインストール
make install-karabiner  # ~/.config/karabiner/assets/complex_modifications/ に配置
make install-all        # 両方
```

`install-karabiner` はコピー時にバイナリパスを `$(PREFIX)/bin/highlight` に書き換えるので、`PREFIX` を変えれば自動的に追従する（例: `make install-all PREFIX=/usr/local`）。

インストール後、Karabiner-Elements を開き **Settings → Complex Modifications → Add predefined rule** から *Cursor Highlight* を有効化する。

## 使い方

デフォルトでは **左 Control キーの押下で即発火** する設定（`to_if_alone` を使わないので押した瞬間に発動、判定遅延なし）。代わりに左 Control は Control 修飾キーとしては機能しなくなるので、Ctrl+C 等は **右 Control** を使う前提。

他のキーに割り当てたい場合は `karabiner/cursor-highlight.json` の `from.key_code` を編集（`f13`〜`f19` などの未使用キーなら修飾キー機能を犠牲にせず使える）。

直接実行する場合:

```bash
/usr/local/bin/highlight
```

## カスタマイズ

`highlight.swift` 冒頭の定数を変更してリビルド:

| 定数 | デフォルト | 意味 |
| --- | --- | --- |
| `size` | `120` | 円を含むウィンドウの一辺 (pt) |
| `displayDuration` | `0.7` | フェード開始までの時間 (秒) |
| `fadeDuration` | `0.4` | フェードアウトの長さ (秒) |
| `fillColor` | `systemYellow * 0.35` | 内側の塗り色 |
| `strokeColor` | `systemRed` | 枠線の色 |
| `lineWidth` | `5` | 枠線の太さ (pt) |
| `inset` | `8` | ウィンドウからの内側マージン (pt) |

変更後 `make` で再ビルド、`make install` で再配置。

## 既知の制約

- Zoom/Meet/Teams で **特定ウィンドウのみ共有** の場合、オーバーレイは別ウィンドウなので映らない。**画面全体共有** を使うこと。
- 初回実行時に macOS のセキュリティダイアログが出る場合がある。
- Karabiner-Elements の `shell_command` は環境変数が最小なので、バイナリはフルパスで指定している。

## 動作確認

```bash
make run                # その場でビルドして1回実行
```

カーソル位置に黄色の円＋赤い枠線が表示され、約 0.7 秒後にフェードアウトすれば成功。
