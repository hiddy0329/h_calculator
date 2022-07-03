# アプリケーション名
【Flutter 電卓アプリ】
- Flutterを使用して実装した電卓アプリケーション

# 開発環境
- 言語：Dart
- フレームワーク：Flutter
- OS：Windows
- エディター：Visual Studio Code
- データベース：MySQL

# アプリケーション概要
- ユーザー登録/ログインをする
- 電卓で演算を実行する
- 計算結果をデータベースに保存する
- 計算履歴を見る

# テスト用アカウント
- Username: test
- Password: pass

# 利用方法

## ユーザー登録/ログインページ
![db_pointer](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/user_registration_db_pointer.png)![db_connect](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/user_registration_db_connect.png)
- 画面上部のデータベース接続ボタンをタップし、データベースに接続する。
- データベースに接続されるとボタンが点灯する。

![user_login](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/user_registration.png)
- ユーザー名とパスワードを入力し、新規登録/ログインをする。
- 登録/ログインが完了すると、電卓画面へ遷移する。

![db_off](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/db_off.png)![db_off](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/user_login_error.png)
- データベース接続ができていない状態で登録/ログインしようとすると、エラーメッセージが出る。
- 入力に誤りがある場合、エラーメッセージが出る。

## 電卓ページ
![dentaku](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/dentaku.png)

### 画面表示系
- 画面左上に、「現在ログイン中のユーザー名」と「logout」ボタンが表示される。
- 数値ボタンを押すと、その数値が画面に表示される。
- 連続して整数を入力すると桁数が増えていく。
- 整数で9桁まで表示できる。それ以上入力しようとすると何も表示されない。
- 小数点を入力し、その後に数値を入力していくと小数点数を表示できる。
- 小数点数は小数点以下8桁まで表示ができる。それ以上入力しようとすると何も表示されない。
- 「logout」ボタンを押すと、ログアウトし、前の画面に遷移する。
- 右端のボタンを押すと、計算履歴表示ページに遷移する。

### 演算系
- 基本的な四則演算を実行できる。
- 0で割ろうとすると「Infinity」と表示される。
- 0を0で割ろうとすると「NaN」と表示される。
- 「AC」を押すと、それまでの演算をクリアし、画面上に「0」を表示する。
- 「+/-」を押すと、符号が切り替わる。
- 「Del」を押すと、一の位の数を削除していく。
- 演算結果はデータベースに保存されていく。

## 計算履歴表示ページ
![no_history](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/no_history.png)![no_history](https://brain-j.backlog.com/git/KADAI/hidai-calculator/raw/master/my_app/images/history.png)
- 履歴が無い場合は、メッセージが表示される。
- 最大10件まで更新順に計算式と計算結果が表示される。
- 上部にログイン中のユーザー名が表示される。

# 制作背景(意図)
- Flutterを利用した研修として、「電卓アプリ」を実装。

# 実装した機能
- ユーザー登録/ログイン機能
- 四則演算機能
- オールクリア機能
- 符号切り替え機能
- 削除機能
- 計算結果保存機能
- 計算履歴表示機能
- データベース接続ステータス表示機能
- 外部パッケージ「Shared_preference」を使用したデータの端末保存機能

# 工夫したポイント

## UI
- ボタンの色や表示されているテキストに関して視認性の高いデザインを目指したこと。
- 画面遷移時にアニメーションを付け、ユーザビリティの向上を狙ったこと。
- Google Fontを導入し、フォントの統一をしたこと。

## ロジック
- 二項のみではなく、何項でも続けて演算できるようにしたこと。
- ユーザーログイン時の認証機能を自ら実装したこと。
- ユーザーごとに計算履歴の表示を切り替えることができるようにしたこと。

# 苦労したポイント
- 「静的型付け」という仕組みに慣れるまでに時間が掛かったこと。
- 演算の際に必要な変数全ての流れを考えて条件分岐を行いながら実装をする必要があったこと。
- 演算と画面表示の双方で型変換をしなければならず、状況に応じて細かく条件分岐する必要があったこと。
- 初めて体験するフレームワークを使用した研修全体のスケジュール管理。

# 課題や今後実装したい機能

## 課題
- ユーザー登録時にパスワードを暗号化して登録するように実装すること。(パッケージ「encrypt」を使用？)
- データ保存や取得時のSQLインジェクションへの対策をすること。(尚、flutterの外部パッケージ「mysql1」にはデフォルトで対策機能が付いている)
- 履歴ページに計算結果だけでなく、式も含めて表示できるように実装すること。
- UIとロジックに関してコーディングファイルの切り分けをすること。

## 今後実装したい機能
- ボタン押下時に音をつける。
- 電卓のUIに関して、ユーザーが好きな色やデザインを選べるようにする。
- 円をドルに変換する機能をつける。

# データベース設計

## usersテーブル
| Column               | Type       | Options                        |
| ------               | ---------- | ------------------------------ |
| id                   | integer    | Auto Increment                 |
| username             | string     | null: false                    |
| password             | string     | null: false                    |

## caluculationsテーブル
| Column               | Type       | Options                        |
| ------               | ---------- | ------------------------------ |
| id                   | integer    | Auto Increment                 |
| result               | double     |                                |
| user_id              | integer    |                                |


# 備考・参考にしたサイト

## Flutter公式
- https://flutter.dev/

## Flutter学習
- https://www.udemy.com/course/flutter-dart/
- https://www.udemy.com/course/flutter-bootcamp-with-dart/
- https://qiita.com/matsukatsu/items/e289e30231fffb1e4502
- https://try.dartlang.org/?

## UI関連
- https://pub.dev/packages/font_awesome_flutter
- https://fonts.google.com/

## セキュリティ関連
- https://techsmeme.com/flutter-env/
- https://blog.dalt.me/2810
- https://pub.dev/packages/flutter_dotenv
- https://pub.dev/packages/encrypt

## データベース関連
- https://note.com/hatchoutschool/n/n1ecf9828957d
- https://www.wenyanet.com/opensource/ja/5ffd0f952c0ba732d74cc031.html
- https://pub.dev/packages/mysql1
- https://pub.dev/packages/shared_preferences


