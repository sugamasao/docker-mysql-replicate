# docker-mysql-replicate
DockerのMySQLを使ってかんたんにレプリケーション環境を作ります

## 動作させるには

```sh
% docker-compose up
```

マスターへアクセス

```sh
% mysql -h 127.0.0.1 -P 33061 -u root -p
```

スレーブへアクセス

```sh
% mysql -h 127.0.0.1 -P 33062 -u root -p
```

## メモ

- ユーザーはrootのみ。パスワード指定なし
- `port 33061` でmasterのコンテナが起動する
- `port 33062` でslaveのコンテナが起動する
- レプリケーション自体は動かしているが、既存データの同期はしていない
  - そもそもdocker-composeで同時に動かすので、生まれた時からデータはレプリケートされているでしょ、という割り切り
