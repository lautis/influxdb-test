## Dependencies

* influxdb 0.8 (`brew tap homebrew/versions; brew install homebrew/versions/influxdb08`)
* sqlite
* Ruby 2.2 & bundler


## Setup

Install gems with `bundle install`.

InfluxDB configuration assumes that you have the default (unsafe) password. Databases can be set up with `rake db:setup`. This should load schema for influxdb as well.

Manual rake tasks

* `influxdb:create` - create influxdb db
* `influxdb:drop` - drop influxdb db
* `influxdb:continuous_queries` - set up continuous queries

## Usage

## POST /api/1/pings

```
curl -i -X POST -H "Content-Type: application/json" -d '{"origin": "sdn-probe-moscow","name_lookup_time_ms": 203,"connect_time_ms": 413,"transfer_time_ms": 135,"total_time_ms": 752,"status": 200}' http://localhost:3000/api/1/pings
```

## /

Shows a graph of pings per origin.

## Caveats

InfluxDB notes on downsampling continuous queries

> It’s important to note that this happens as soon as the hour has elapsed. So if you have delayed data collection, this number may be off. Watch this issue for when that will change.

New pings might take some time to appear in the dashboard UI. In hindsight, perhaps a downsampling rate less than an hour might've been useful.
