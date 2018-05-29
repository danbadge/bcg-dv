# bcg-dv

Exec into container:
```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d && docker-compose exec web-app bash
```

To do:

Rubocop
Validation against endpoint
Main task combining data from multiple CSVs
Delays data
Can it run without docker?
Readme