import os
import net.http
import net.urllib

const base_url = 'https://jp1.api.riotgames.com'

const path = '/tft/league/v1/challenger'

fn main() {
	key := os.getenv('API_KEY')
	mut url := urllib.parse(base_url) or { panic('Failed to parse the url.') }
	url.path = path
	println(url.str())

	mut h := http.new_header()
	h.add_custom('X-Riot-Token', key) or { panic('Failed to add header.') }
	r := http.fetch(url.str(), http.FetchConfig{
		header: h
	}) or { panic('Failed to fetch.') }
	if r.status_code != 200 {
		panic('Failed to fetch. $r.status_code')
	}

	println(r.text)
}
