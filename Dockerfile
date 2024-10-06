# ベースイメージとして公式のnginxイメージを使用
FROM nginx:latest

# カスタムのHTMLファイルをnginxのデフォルトのドキュメントルートにコピー
COPY ./index.html /usr/share/nginx/html/index.html

# Nginxが使用するポートを公開
EXPOSE 80

# コンテナが起動した際にnginxを起動する
CMD ["nginx", "-g", "daemon off;"]
