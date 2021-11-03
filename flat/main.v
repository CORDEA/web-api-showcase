import os
import net.http
import net.urllib

const base_url = 'https://api.flat.io'

const path = '/v2/scores'

fn main() {
	token := os.getenv('API_TOKEN')

	mut url := urllib.parse(base_url) or { panic('Failed to parse the url.') }
	url.path = path
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
}
