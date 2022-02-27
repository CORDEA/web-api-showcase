import os
import net.http
import net.urllib

const authorize_url = 'https://accounts.spotify.com/authorize'

const token_url = 'https://accounts.spotify.com/api/token'

const base_url = 'https://api.spotify.com/v1'

fn main() {
	id := os.getenv('CLIENT_ID')
	mut url := urllib.parse(authorize_url) or { panic('Failed to parse the url.') }
	url.raw_query = 'client_id=$id&response_type=code&redirect_uri=http://localhost&state=xxx'
	println(url.str())

	redirect := os.input('Enter url: ')
	url = urllib.parse(redirect) or { panic('Failed to parse the url.') }
	q := urllib.parse_query(url.raw_query) or { panic('Failed to parse the query.') }
	code := q.get('code')
	if q.get('state') != 'xxx' {
		panic('Invalid url.')
	}
}
