Tweet-to-Smoke
==============

We turn tweets into fog machine smoke signals.

im twelve what is this
-----

We created a Twitter account, @TweetToSmoke, which could be used to send @replies to. Using some code based on the open-source Ruby-based retjilp retweeting bot, we were able to set up an oath-enabled application to view TweetToSmoke's @replies on an rackspace cloud instance using plain Ruby CGI (no Rails needed). The CGI script returned the latest reply's text. From there, an Arduino with an ethernet shield was programmed to parse out the text and convert each character into morse code and from there, into an audio tone which would be amplified and sent to a large bass subwoofer pointed in the center near the top of the inside of a trash can with a fog machine stuffed inside. The frequencies used and the placement of the sound system allowed us to generate small rings and long puffs of smoke which were viewable indoors, but not so thick that we would end up getting a visit from the Fire Department (again).
