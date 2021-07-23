import os
import net.http
import net.urllib

const base_url = 'https://api.nytimes.com'
const path = '/svc/archive/v1/2019/1.json'

fn main() {
	key := os.getenv('API_KEY')
	mut url := urllib.parse(base_url) or {
		panic('Failed to parse the url.')
		return
	}
	url.path = path
	url.raw_query = 'api-key=$key'
	println(url.str())

	r := http.get(url.str()) or {
		panic('Failed to fetch.')
		return
	}
	if r.status_code != 200 {
		panic('Failed to fetch. ${r.status_code}')
		return
	}

	println(r.text)
}
