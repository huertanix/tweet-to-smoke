Tweet-to-Smoke
==============

We turn tweets into fog machine smoke signals.

Purpose
-------

Our Red Bull Creation project's aim is to provide a means to connect one of the newest forms of human mass-communication (Twitter) with the oldest (smoke signals).  Our team, the Triad, was made up of a mix of different skill sets and talents which came in handy when dealing with both JSON parsing and fog machine smoke shaping.  It boils down to a few steps:

### Twitter Parsing
We created a Twitter account, @TweetToSmoke, which could be used to send @replies to.  Using some code based on the open-source Ruby-based retjilp retweeting bot, we were able to set up an oauth-enabled application to view TweetToSmoke's @replies on an Ubuntu cloud server using plain Ruby CGI over Apache (no Rails needed).  The CGI script returned the latest reply's text.

### Web-to-Morse
An Arduino with an ethernet shield was programmed to connect to the cloud server via HTTP and parse out the text (handily delimited with a $) and convert each character into morse code. From there, text-to-morse-code scripts were found and the Arduino Tone library was used to translate the tweet into an audio tone which would be sent out via a normal 3.5mm headphone jack.

### Audio-to-Smoke
The Arduino output 100 Hz tones of varying lengths to a large subwoofer speaker placed inside a trash can with a fog machine stuffed on top.  The frequencies used and the placement of the sound system allowed us to generate small rings and long puffs of smoke which were viewable indoors, but not so thick that we would fill our Fire Department visit quota for the week.