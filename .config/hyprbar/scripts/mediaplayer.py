#!/usr/bin/env python3
import gi
gi.require_version("Playerctl", "2.0")
from gi.repository import Playerctl, GLib
import sys
import signal
import json
import logging
import os

# Optional logging
logger = logging.getLogger("mediaplayer")
logging.basicConfig(level=logging.WARNING)

# Mapping player names to icons
PLAYER_ICONS = {
    "spotify": "",
    "vlc": "🎬",
    "mpv": "🎵",
    "rhythmbox": "🎶",
    "cmus": "🎧",
    "default": ""
}

PLAY_ICON = ""
PAUSE_ICON = ""

def safe_text(text: str) -> str:
    """Escape quotes/newlines to prevent JSON errors."""
    return text.replace('"', "'").replace("\n", " ").strip()

class MediaPlayer:
    def __init__(self, selected_player=None, excluded_players=None):
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()
        self.selected_player = selected_player
        self.excluded_players = excluded_players.split(",") if excluded_players else []

        # Connect signals
        self.manager.connect("name-appeared", self.on_player_appeared)
        self.manager.connect("player-vanished", self.on_player_vanished)

        signal.signal(signal.SIGPIPE, signal.SIG_DFL)  # Ignore broken pipe

        self.init_players()

    def init_players(self):
        for name in self.manager.props.player_names:
            if name in self.excluded_players:
                continue
            if self.selected_player and self.selected_player != name:
                continue
            self.init_player(name)

    def init_player(self, player_name: str):
        try:
            player = Playerctl.Player.new_from_name(player_name)
            player.connect("metadata", self.on_metadata_changed)
            player.connect("playback-status", self.on_status_changed)
            self.manager.manage_player(player)
            # Show initial metadata
            self.on_metadata_changed(player, player.props.metadata)
        except Exception as e:
            logger.warning(f"Failed to initialize player {player_name}: {e}")

    def run(self):
        self.loop.run()

    def get_first_playing_player(self):
        players = self.manager.props.players
        # Prefer currently playing
        for p in reversed(players):
            if p.props.status == "Playing":
                return p
        # Otherwise first paused player
        return players[0] if players else None

    def show_player(self, player):
        if not player:
            self.clear_output()
            return
        metadata = player.props.metadata
        artist = player.get_artist() or ""
        title = player.get_title() or ""
        track_info = f"{artist} - {title}" if artist else title
        track_info = safe_text(track_info)

        # Determine icon
        icon = PLAYER_ICONS.get(player.props.player_name.lower(), PLAYER_ICONS["default"])
        if player.props.status == "Playing":
            track_info = f"{PLAY_ICON} {icon} {track_info}"
        else:
            track_info = f"{PAUSE_ICON} {icon} {track_info}"

        output = {
            "text": track_info,
            "class": f"custom-{player.props.player_name}",
            "alt": player.props.player_name
        }
        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()

    def clear_output(self):
        sys.stdout.write("\n")
        sys.stdout.flush()

    def on_metadata_changed(self, player, metadata, *_):
        # Only show if no other player is currently playing or it's this one
        current = self.get_first_playing_player()
        if not current or current.props.player_name == player.props.player_name:
            self.show_player(player)

    def on_status_changed(self, player, status, *_):
        self.on_metadata_changed(player, player.props.metadata)

    def on_player_appeared(self, manager, player_name):
        if player_name in self.excluded_players:
            return
        if not self.selected_player or self.selected_player == player_name:
            self.init_player(player_name)

    def on_player_vanished(self, manager, player):
        # Update display when a player disappears
        self.show_player(self.get_first_playing_player())


def main():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--player", help="Filter for specific player")
    parser.add_argument("-x", "--exclude", help="Comma-separated players to exclude")
    parser.add_argument("-v", "--verbose", action="count", default=0)
    parser.add_argument("--enable-logging", action="store_true")
    args = parser.parse_args()

    # Setup logging
    if args.enable_logging:
        logfile = os.path.join(os.path.dirname(os.path.realpath(__file__)), "media-player.log")
        logging.basicConfig(filename=logfile, level=logging.DEBUG,
                            format="%(asctime)s %(levelname)s:%(message)s")

    logger.setLevel(max(3 - args.verbose, 0) * 10)

    mp = MediaPlayer(selected_player=args.player, excluded_players=args.exclude)
    mp.run()


if __name__ == "__main__":
    main()
  