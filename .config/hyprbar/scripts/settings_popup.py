#!/usr/bin/env python3
import gi, sys
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk, GLib, Gdk

class SettingsPopup(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="com.wreana.settingspopup")
        self.win = None

    def do_activate(self):
        if not self.win:
            self.win = Gtk.Window(application=self, title="Settings", default_width=300, default_height=600)
            self.win.set_resizable(False)
            self.win.set_name("settings_popup")  # for CSS

            # Apply CSS
            style_provider = Gtk.CssProvider()
            style_provider.load_from_path("/home/wreana/.config/hyprbar/gtk.css")
            display = Gdk.Display.get_default()
            Gtk.StyleContext.add_provider_for_display(
                display, style_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER
            )

            # --- Add content ---
            box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
            self.win.set_child(box)

            # Volume slider
            vol_label = Gtk.Label(label="Volume")
            vol_scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
            vol_scale.set_value(int(GLib.spawn_command_line_sync("pactl get-sink-volume @DEFAULT_SINK@")[1].decode().split("%")[0].split()[-1]))
            vol_scale.connect("value-changed", lambda s: GLib.spawn_command_line_async(f"pactl set-sink-volume @DEFAULT_SINK@ {int(s.get_value())}%"))
            box.append(vol_label)
            box.append(vol_scale)

            # Brightness slider
            brt_label = Gtk.Label(label="Brightness")
            brt_scale = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1)
            val = int(GLib.spawn_command_line_sync("brightnessctl get")[1].decode())
            max_val = int(GLib.spawn_command_line_sync("brightnessctl max")[1].decode())
            brt_scale.set_value(val*100/max_val)
            brt_scale.connect("value-changed", lambda s: GLib.spawn_command_line_async(f"brightnessctl set {int(s.get_value())}%"))
            box.append(brt_label)
            box.append(brt_scale)

            # Close button
            btn = Gtk.Button(label="Close")
            btn.connect("clicked", lambda b: self.win.hide())
            box.append(btn)

        self.win.present()

if __name__ == "__main__":
    app = SettingsPopup()
    app.run(sys.argv)
