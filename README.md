# bcg-dv

Exec into container:
```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d && docker-compose exec web-app bash
```