import cli
import os
import net.http
import net.urllib
import x.json2
import json

const base_url = 'https://www.alphavantage.co'

const path = '/query'

const function = 'TIME_SERIES_INTRADAY'

struct Response {
	meta        Meta
	time_series TimeSeries
}

struct Meta {
mut:
	information    string
	symbol         string
	last_refreshed string
	interval       string
	output_size    string
	time_zone      string
}

fn (mut m Meta) from_json(j json2.Any) {
	obj := j.as_map()
	for k, v in obj {
		match k {
			'1. Information' { m.information = v.str() }
			'2. Symbol' { m.symbol = v.str() }
			'3. Last Refreshed' { m.last_refreshed = v.str() }
			'4. Interval' { m.interval = v.str() }
			'5. Output Size' { m.output_size = v.str() }
			'6. Time Zone' { m.time_zone = v.str() }
			else {}
		}
	}
}

struct TimeSeries {
mut:
	series map[string]Value
}

fn (mut t TimeSeries) from_json(j json2.Any) {
	obj := j.as_map()
	for k, v in obj {
		mut val := Value{}
		val.from_json(v)
		t.series[k] = val
	}
}

struct Value {
mut:
	open   string
	high   string
	low    string
	close  string
	volume string
}

fn (mut l Value) from_json(j json2.Any) {
	obj := j.as_map()
	for k, v in obj {
		match k {
			'1. open' { l.open = v.str() }
			'2. high' { l.high = v.str() }
			'3. low' { l.low = v.str() }
			'4. close' { l.close = v.str() }
			'5. volume' { l.volume = v.str() }
			else {}
		}
	}
}

fn main() {
	mut cmd := cli.Command{
		name: 'alphavantage'
		execute: run
	}
	cmd.add_flag(cli.Flag{
		flag: .string
		required: true
		name: 'symbol'
	})
	cmd.add_flag(cli.Flag{
		flag: .string
		required: true
		name: 'interval'
	})
	cmd.setup()
	cmd.parse(os.args)
}

fn run(cmd cli.Command) ? {
	key := os.getenv('API_KEY')
	if key.len < 1 {
		panic('Api key is required.')
	}
	symbol := cmd.flags.get_string('symbol') or { panic('Symbol is required.') }
	interval := cmd.flags.get_string('interval') or { panic('Interval is required.') }

	mut url := urllib.parse(base_url) or { panic('Failed to parse the url.') }
	url.path = path
	url.raw_query = 'function=$function&symbol=$symbol&interval=$interval&apikey=$key'
	println(url.str())

	r := http.get(url.str()) or { panic('Failed to fetch.') }
	if r.status_code != 200 {
		panic('Failed to fetch. $r.status_code')
	}

	json := json2.raw_decode(r.text) or { panic('Failed to parse json.') }
	mapped := json.as_map()

	mut meta := Meta{}
	meta.from_json(mapped['Meta Data'])
	mut time_series := TimeSeries{}
	time_series.from_json(mapped['Time Series ($interval)'])
	response := Response{meta, time_series}
	println(response)
}
