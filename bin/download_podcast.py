#!/usr/bin/env python
import os
import requests
import feedparser
import argparse
import string
from datetime import datetime

def download_podcast_episodes(feed_url):
    # Parse the RSS feed
    feed = feedparser.parse(feed_url)

    # Create a directory to save the downloaded files
    if not os.path.exists("podcast_episodes"):
        os.makedirs("podcast_episodes")

    # Iterate over each episode in the feed
    for entry in feed.entries:
        episode_title = entry.title

        # Extract the MP3 URL
        enclosure_url = entry.enclosures[0].href

        # Remove special characters from the title
        valid_chars = "-_.() %s%s" % (string.ascii_letters, string.digits)
        episode_title = ''.join(c for c in episode_title if c in valid_chars)

        # Get the publication date
        pub_date = entry.published
        pub_date = datetime.strptime(pub_date, "%a, %d %b %Y %H:%M:%S %Z")

        # Create a date prefix for the file name
        date_prefix = pub_date.strftime("%Y-%m-%d")

        # Download the MP3 file
        response = requests.get(enclosure_url)
        if response.status_code == 200:
            # Save the MP3 file with the date prefix and episode title
            file_name = f"podcast_episodes/{date_prefix}_{episode_title}.mp3"
            with open(file_name, "wb") as file:
                file.write(response.content)
                print(f"Downloaded: {file_name}")
        else:
            print(f"Failed to download: {episode_title}")

# Parse the command-line arguments
parser = argparse.ArgumentParser(description="Download MP3 files from a podcast feed.")
parser.add_argument("feed_url", help="URL of the podcast RSS feed")
args = parser.parse_args()

# Download podcast episodes
download_podcast_episodes(args.feed_url)
