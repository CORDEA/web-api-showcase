import cli
import os
import net.http
import net.urllib
import json

const base_url = 'https://api.flat.io'

const path = '/v2/scores'

struct Score {
	id          string
	title       string
	html_url    string [json: 'htmlUrl']
	subtitle    string
	lyricist    string
	arranger    string
	composer    string
	description string
}

fn main() {
	mut cmd := cli.Command{
		name: 'flat'
		execute: run
	}
	cmd.add_flag(cli.Flag{
		flag: .string
		required: true
		name: 'id'
	})
	cmd.setup()
	cmd.parse(os.args)
}

fn run(cmd cli.Command) ? {
	token := os.getenv('API_TOKEN')

	mut url := urllib.parse(base_url) or { panic('Failed to parse the url.') }
	url.path = path + '/' + cmd.flags.get_string('id') or { panic('ID is required.') }
	println(url.str())

	mut h := http.new_header()
	h.add_custom('Authorization', 'Bearer $token') or { panic('Failed to add header.') }
	r := http.fetch(
		url: url.str()
		header: h
	) or { panic('Failed to fetch.') }
	if r.status_code != 200 {
		panic('Failed to fetch. $r.status_code')
	}

	data := json.decode(Score, r.text) or { panic('Failed to parse response.') }
	println(data)
}
