require 'bundler/setup'

require 'dotenv'
require 'addressable/uri'
require 'restclient'
require 'dropbox_sdk'
require 'date'

Dotenv.load

endpoint = "https://api.trello.com/1/boards/#{ENV['TRELLO_BOARD_ID']}"
uri = Addressable::URI.parse(endpoint)
uri.query_values = {
  :actions => :all,
  :actions_limit => 1000,
  :cards => :all,
  :lists => :all,
  :members => :all,
  :member_fields => :all,
  :checklists => :all,
  :fields => :all,
  :key => ENV['TRELLO_KEY'],
  :token => ENV['TRELLO_TOKEN']
}
response = RestClient.get(uri.to_s)
json = response.body

client = DropboxClient.new(ENV['DROPBOX_ACCESS_TOKEN'])
client.put_file("/#{Date.today}-trello.json", json)