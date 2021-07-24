import cli
import os
import json
import net.http
import net.urllib

const base_url = 'https://www.alphavantage.co'

const path = '/query'

const function = 'TIME_SERIES_INTRADAY'

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
}
