import os
import json
import net.http
import net.urllib

const base_url = 'https://api.igdb.com'

const path = '/v4/games'

fn authenticate(id string, secret string) string {
	mut url := urllib.parse('https://id.twitch.tv') or { panic('Failed to parse the url.') }
	url.path = '/oauth2/token'
	url.raw_query = 'client_id=$id&client_secret=$secret&grant_type=client_credentials'
	println(url.str())
	r := http.post(url.str(), '') or { panic('Failed to authenticate.') }
	if r.status_code != 200 {
		panic('Failed to authenticate. $r.status_code')
	}
	data := json.decode(map[string]string, r.text) or { panic('Failed to parse response.') }
	return data['access_token']
}

fn main() {
	id := os.getenv('CLIENT_ID')
	secret := os.getenv('CLIENT_SECRET')
	token := authenticate(id, secret)
}
