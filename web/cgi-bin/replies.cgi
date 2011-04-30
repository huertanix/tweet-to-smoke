#!/usr/bin/env ruby

#
# Retjilp -- A Native Auto-retweet bot
# Now with cybersauce!
#
# Webpage: http://el-tramo.be/blog/retjilp
# Author: Remko Tronçon (http://el-tramo.be)
# Remixer: David Huerta (http://www.davidhuerta.me)
# License: BSD (see COPYING file)
#
# Usage: retjilp.rb [ --help ] [ --verbose | --debug ]
#
# See README for detailed usage instructions.
#

require 'cgi'
require 'rubygems'
require 'oauth'
require 'json/pure'

# This code 

# Constants
twitter_uri = "http://api.twitter.com"

# Helper method to verify the validity of an access token
def verify_token(token)
        return token.get("/account/verify_credentials.json").class == Net::HTTPOK
end

# Initialize data dir
#data_dir = File.expand_path("~/public_html/cgi-bin") # Change this for prod...
config_filename = "../../config"
access_token_filename = "../../access_token"

# Read configuration file
config = nil
begin
        File.open(config_filename) do |f|
                config = JSON.load(f)
        end
rescue JSON::ParserError => e
        puts "Error parsing configuration file " + config_filename + ": " + e
rescue
        puts "Error loading configuration file " + config_filename
end

# Initialize the access token
access_token = nil
if File.exist?(access_token_filename) :
        # Try using the cached token
        File.open(access_token_filename) do |f|
                begin
                        access_token_data = JSON.load(f)
                        consumer = OAuth::Consumer.new(config["consumer_key"], config["consumer_secret"], { :site => twitter_uri })
                        access_token = OAuth::AccessToken.new(consumer, access_token_data["token"], access_token_data["secret"])
                        if not verify_token(access_token)
                                puts "Cached token not authorized"
                                access_token = nil
                        end
                rescue JSON::ParserError
                        puts "Cached token does not parse"
                end
        end
end

# Grab @replies
latest_mention = JSON.parse(access_token.get("/statuses/mentions.json?count=1&trim_user=true").body)[0]['text']
latest_mention.gsub!(/@([A-Za-z0-9_]+) /, '');
#Spit out @replies
puts "Content-type: text/html \r\n\r\n"
puts (latest_mention.nil? ? "FAILWHALE" : "$" + latest_mention)