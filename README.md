# Open Library Integration Demo

## Local Development

```
gem install bundler
bundle install
bundle exec rackup -p 9292 config.ru
open http://localhost:9292
```

## Testing
The app includes rspec unit tests and end-to-end capybara tests using Rack driver, thus the JS handlers can't be tested yet and require another driver.

```
bundle exec rspec
```

## Deployment
The app is deployed to https://openlib-demo.herokuapp.com/ via Heroku's pipeline.

## API Format

Sample request:
* https://openlib-demo.herokuapp.com/search?title=abba

Response:

```json
{
  "success": true,
  "payload": [
    {
      "title": "Abba Abba",
      "authors": "Anthony Burgess",
      "link": "https://openlibrary.org/works/OL1386723W"
    },
    {
      "title": "ABBA Gold - Greatest Hits",
      "authors": "ABBA",
      "link": "https://openlibrary.org/works/OL26541836W"
    },
    ...
  ]
}
```

## Screenshots
<img width="879" alt="image" src="https://user-images.githubusercontent.com/8615227/226424075-26530985-ff4d-41b0-80e2-78bffcf759da.png">
