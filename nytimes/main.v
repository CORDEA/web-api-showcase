import os
import json
import net.http
import net.urllib

const base_url = 'https://api.nytimes.com'

const path = '/svc/archive/v1/2019/1.json'

struct Data {
	copyright string
	response  Response
}

struct Response {
	meta Meta
	docs []Article
}

struct Meta {
	hits int
}

struct Article {
	web_url          string
	snippet          string
	print_page       int
	source           string
	multimedia       Multimedia
	headline         Headline
	keywords         []Keyword
	pub_date         string
	document_type    string
	news_desk        string
	byline           Byline
	type_of_material string
	id               string     [json: '_id']
	word_count       int
	score            int
	uri              string
}

struct Multimedia {
	rank      int
	subtype   string
	caption   string
	credit    string
	typ       string [json: 'type']
	url       string
	height    int
	width     int
	crop_name string
}

struct Headline {
	main           string
	kicker         string
	content_kicker string
	print_headline string
	name           string
	seo            string
	sub            string
}

struct Keyword {
	name  string
	value string
	rank  int
	major string
}

struct Byline {
}

fn main() {
	key := os.getenv('API_KEY')
	mut url := urllib.parse(base_url) or { panic('Failed to parse the url.') }
	url.path = path
	url.raw_query = 'api-key=$key'
	println(url.str())

	r := http.get(url.str()) or { panic('Failed to fetch.') }
	if r.status_code != 200 {
		panic('Failed to fetch. $r.status_code')
	}

	data := json.decode(Data, r.text) or { panic('Failed to parse response.') }
	println(data)
}
