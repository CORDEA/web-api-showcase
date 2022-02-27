import os
import json
import net.http
import net.urllib
import encoding.base64

const authorize_url = 'https://accounts.spotify.com/authorize'

const token_url = 'https://accounts.spotify.com/api/token'

const base_url = 'https://api.spotify.com/v1'

const redirect_url = 'http://localhost'

const state = 'xxx'

struct AccessToken {
	access_token string
	token_type   string
	scope        string
}

fn main() {
	id := os.getenv('CLIENT_ID')
	secret := os.getenv('CLIENT_SECRET')
	mut url := urllib.parse(authorize_url) or { panic('Failed to parse the url.') }
	url.raw_query = 'client_id=$id&response_type=code&redirect_uri=$redirect_url&state=$state'
	println(url.str())

	redirect := os.input('Enter url: ')
	url = urllib.parse(redirect) or { panic('Failed to parse the url.') }
	q := urllib.parse_query(url.raw_query) or { panic('Failed to parse the query.') }
	code := q.get('code')
	if q.get('state') != state {
		panic('Invalid url.')
	}

	url = urllib.parse(token_url) or { panic('Failed to parse the url.') }
	mut h := http.new_header(key: .content_type, value: 'application/x-www-form-urlencoded')
	auth := base64.encode_str('$id:$secret')
	h.add_custom('Authorization', 'Basic $auth') or { panic('Failed to add header.') }
	body := http.url_encode_form_data({
		'code':         code
		'redirect_uri': redirect_url
		'grant_type':   'authorization_code'
	})
	r := http.fetch(
		method: .post
		url: url.str()
		data: body
		header: h
	) or { panic('Failed to fetch.') }
	if r.status_code != 200 {
		panic('Failed to fetch. $r.status_code')
	}

	data := json.decode(AccessToken, r.text) or { panic('Failed to parse response.') }
	println(data)
}
