import os
import json
import net.http
import net.urllib

const base_url = 'https://jp1.api.riotgames.com'

const path = '/tft/league/v1/challenger'

struct Leagues {
	league_id string       [json: 'leagueId']
	entries   []LeagueItem
	tier      string
	name      string
	queue     string
}

struct LeagueItem {
	fresh_blood   bool       [json: 'freshBlood']
	wins          int
	summoner_name string     [json: 'summonerName']
	mini_series   MiniSeries [json: 'miniSeries']
	inactive      bool
	veteran       bool
	hot_streak    bool       [json: 'hotStreak']
	rank          string
	league_points int        [json: 'leaguePoints']
	losses        int
	summoner_id   string     [json: 'summonerId']
}

struct MiniSeries {
	losses   int
	progress string
	target   int
	wins     int
}

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

	data := json.decode(Leagues, r.text) or { panic('Failed to parse response.') }
	println(data)
}
