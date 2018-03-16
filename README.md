# 旅立ちSwimee 2018

旅立ちSwimee2018に向けてのアプリ

## フロー

- cloneして念のため `pod install`
- `git checkout -b mentor_name`などで自分の作業ブランチを切る
- 適宜編集、そしたらプルリクをGitHub上で作成、レビュー依頼をいい感じに
- デザインは design.sketch で。https://github.com/mathieudutour/git-sketch-plugin をなるべく入れておく。(AdobeXDでも開けるらしいからもしそっちがよかったらそっちでも可。)
- 仕様に対する提案はREADMEにプルリクをする
- 見つけた問題や、他の人に投げたい仕事は適宜Issueに登録する

## 仕様・要件（仮）

- ログイン画面 ... ログインと登録の２つ、卒業iPhoneメンターには専用のアカウントが配布される。登録ではニックネームと写真が必要。
- （現役）卒業iPhoneメンターリスト ... そこから各メンターにメッセージを登録できる画面に飛べる。メッセージに含められるのは文章と写真（暫定）
- （現役）ニックネーム・プロフ写真登録設定画面 ... このデータを使って卒業メンター側のタイムラインを構成。登録時と設定の二箇所で可能。
- （卒業）メッセージ一覧 ... 形式はデザイン次第だけど、一人ひとりのメッセージが見れる
- （卒業）写真一覧 ... みんなから寄せられた写真を一覧で見れる

## ご無沙汰な人のためのコマンド講座

適宜追加。

```sh
# ディレクトリ（フォルダ）の移動。パスはドラッグ＆ドロップすると自動で入力
$ cd その場所へのパス
# Cocoapods自体を最新版にする
$ sudo gem install cocoapods
# Podの関係でうまく入ってなくてエラー出たら一旦
$ pod install
# Cocoapodsのライブラリを追加した後は
$ pod install
# アップデートするのは必要だと判断できる人だけで
# ファイルを変更したら、そのディレクトリにいって以下。ここらへんはXcodeからできるようになっているのでそっちのほうが楽かも。
$ git add .
$ git commit -m 'やった内容について説明'
$ git push origin branch_name
# ただしmaster pushはしないように
# ブランチを新しく切る
$ git branch -b new_branch_name
# すでにあるブランチに移る
$ git branch branch_name
# サーバーの最新情報をとってくる
$ git fetch
# プルリク採用された後、masterの状態を更新する
$ git checkout master
$ git pull origin master
# 同じ名前のブランチがすでにあるけどもう新しくしたい
$ git branch -D branch_name
$ git checkout -b branch_name
```

あとpodについては適宜Podfileを見てライブラリのインストール方法のところでも見たら思い出すでしょう。
