# curpop

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

画面共有や録画でマウスカーソル位置を一瞬で目立たせるための macOS 用ユーティリティ。ホットキーで現在のカーソル位置に漫画風の **集中線アニメーション** を表示する。

![curpop のスクリーンショット](./screenshot.png)

## 構成

- `curpop.swift` — 起動するとカーソル位置に集中線を描画して約 2 秒で終了する単発バイナリのソース
- `Makefile` — ビルド／インストール
- `LICENSE` — MIT

## 動作要件

- macOS（Cocoa / QuartzCore が動けば動く範囲。Apple Silicon / Intel ともに想定）
- Swift コンパイラ (`swiftc`)。Xcode または Command Line Tools (`xcode-select --install`) を入れておく
- ホットキー連携したい場合は [Karabiner-Elements](https://karabiner-elements.pqrs.org/) など任意のランチャー

## ビルドとインストール

```bash
make install   # ~/.local/bin/curpop にインストール
```

`PREFIX` でインストール先を変えられる（例: `make install PREFIX=/usr/local`）。

## 使い方

シェルから直接起動:

```bash
~/.local/bin/curpop
~/.local/bin/curpop --scale 1.5 --color "#ff3366"
~/.local/bin/curpop --help
```

## コマンドラインオプション

| オプション | デフォルト | 意味 |
| --- | --- | --- |
| `--scale <数値>` | `1.0` | 全体スケール。`canvasSize` / `innerRadius` / `lineBaseWidth` / `innerJitter` がまとめて倍率変化する |
| `--color <hex>` | `#000000` | 集中線の色。`#RRGGBB` または `#RRGGBBAA` |
| `-h`, `--help` | — | ヘルプを表示して終了 |

ホットキーごとにオプションを変えた複数バリエーションも作れる（後述の Karabiner 例参照）。

## ホットキー設定（Karabiner-Elements）

Karabiner-Elements を使う場合のセットアップ例。リポジトリには JSON を同梱していないので、以下を参考に自分で `~/.config/karabiner/assets/complex_modifications/curpop.json` を作るか、`karabiner.json` の `complex_modifications.rules` に直接追記する。

右 Control + 数字キーでスケール違いを叩き分ける構成が使い勝手が良い。`right_control + 1/2/3/4/5` で `0.5x / 1x / 2x / 4x / 8x` を割り当てる例:

```json
{
  "title": "curpop",
  "rules": [
    {
      "description": "right_control + 1/2/3/4/5 -> curpop variants",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "1",
            "modifiers": { "mandatory": ["right_control"], "optional": ["any"] }
          },
          "to": [
            { "shell_command": "$HOME/.local/bin/curpop --scale 0.5" }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "2",
            "modifiers": { "mandatory": ["right_control"], "optional": ["any"] }
          },
          "to": [
            { "shell_command": "$HOME/.local/bin/curpop" }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "3",
            "modifiers": { "mandatory": ["right_control"], "optional": ["any"] }
          },
          "to": [
            { "shell_command": "$HOME/.local/bin/curpop --scale 2" }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "4",
            "modifiers": { "mandatory": ["right_control"], "optional": ["any"] }
          },
          "to": [
            { "shell_command": "$HOME/.local/bin/curpop --scale 4" }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "5",
            "modifiers": { "mandatory": ["right_control"], "optional": ["any"] }
          },
          "to": [
            { "shell_command": "$HOME/.local/bin/curpop --scale 8" }
          ]
        }
      ]
    }
  ]
}
```

ポイント:

- `mandatory: ["right_control"]` にすることで右 Ctrl 限定にマッチさせ、左 Ctrl + 数字（多くのアプリのショートカット）は通常通り動く。左右にこだわらないなら `"control"` でも可。
- `shell_command` の `curpop` は **絶対パス** で書く。Karabiner-Elements の起動環境は `PATH` が最小なので `~` が展開されない／`curpop` だけだと見つけられないことがある。`PREFIX` を変えてインストールしたら適宜書き換える。
- ファイルを置いたら Karabiner-Elements を開き **Settings → Complex Modifications → Add predefined rule** から有効化する（直接 `karabiner.json` に書いた場合は不要）。
- 用途に応じて `--color "#ff3366"` などを足してさらにバリエーションを増やしてもよい。

Hammerspoon、Raycast、skhd など他のランチャーでも同じ要領でバイナリを叩くだけで動く。

## カスタマイズ

CLI で渡せない項目は `curpop.swift` 冒頭の定数を変更してリビルド (`make install`) する。

| 定数 | デフォルト | 意味 |
| --- | --- | --- |
| `canvasSize` | `560` | 集中線を描く正方形ウィンドウの一辺 (pt)。`--scale` で倍率変化 |
| `lineCount` | `512` | 1 フレームあたりの線の本数 |
| `innerRadius` | `44` | 中心側の空き半径 (pt)。さらに 0〜64 のランダム揺らぎが加算される |
| `lineBaseWidth` | `2` | 線幅の基準値 (pt)。各線で 0.55〜1.25 倍にゆらぐ |
| `frameInterval` | `0.12` | フレーム更新間隔 (秒) |
| `frameCount` | `16` | 総フレーム数。総再生時間は `frameInterval * frameCount` |
| `accentColor` | `NSColor.black` | 集中線の色のデフォルト。`--color` で上書き |

## 既知の制約

- Zoom / Google Meet / Teams で **特定ウィンドウのみ共有** している場合、オーバーレイは別ウィンドウなので相手側には映らない。**画面全体共有** を使うこと。
- 初回実行時に macOS のセキュリティダイアログが出る場合がある。
- Karabiner-Elements の `shell_command` は環境変数が最小なので、バイナリは絶対パスで指定する。

## 動作確認

```bash
make run    # その場でビルドして 1 回だけ実行
```

カーソル位置から黒い集中線が放射状にちらつき、約 2 秒で消えれば成功。

## ライセンス

[MIT License](./LICENSE) © 2026 usp
