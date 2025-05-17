# Redis
sudo docker run -d --restart unless-stopped -p "127.0.0.1:6379:6379" --name=redis redis:7

# PostgresSQL
sudo docker run -d --restart unless-stopped -p "127.0.0.1:5432:5432" --name=postgres16 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:16
