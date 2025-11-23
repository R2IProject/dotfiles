import app from "ags/gtk4/app"
import { Gtk, Gdk, Astal } from "ags/gtk4"
import { exec } from "ags/process"
import { createPoll } from "ags/time"
import { createState } from "gnim"

export default function Floating(gdkmonitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor
  const [username, setUsername] = createState<string>("")
  const [revealer, setRevealer] = createState<boolean>(false)

  // ===== USERNAME =====
  setUsername(() => {
    const name = exec(["bash", "-c", "whoami"]).trim()
    return name.charAt(0).toUpperCase() + name.slice(1)
  })

  // ===== BRIGHTNESS =====
  const rawMaxBrightness = parseInt(exec(["bash", "-c", "brightnessctl max"]).trim(), 10)

  const brightness = createPoll<number>(0, 1000, () => {
    const rawCurrent = parseInt(exec(["bash", "-c", "brightnessctl get"]).trim(), 10)
    return Math.trunc((rawCurrent * 100) / rawMaxBrightness)
  })

  // ===== VOLUME =====
  const volume = createPoll<number>(0, 1000, () => {
    const volStr = exec([
      "bash",
      "-c",
      "pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -n 1"
    ]).trim()
    return parseInt(volStr, 10)
  })

  // ===== WINDOW TOGGLE =====
  app.connect("window-toggled", (_app: any, win: any) => {
    const name = win.get_name()
    const visible = win.visible ?? win.get_visible?.() ?? false
    if (name === "floating") setRevealer(visible)
  })

  // ===== UPTIME =====
  const uptime = createPoll<string>("", 1000, () => {
    const out = exec(["bash", "-c", "cut -d ' ' -f1 /proc/uptime"]).trim()
    const total = Math.floor(parseFloat(out))

    const hrs = Math.floor(total / 3600)
    const mins = Math.floor((total % 3600) / 60)
    const secs = total % 60

    return `Up: ${hrs}h ${mins}m ${secs}s`
  })

  return (
    <window
      name="floating"
      class="FloatingWindow"
      application={app}
      gdkmonitor={gdkmonitor}
      visible={false}
      resizable={false}
      anchor={TOP | RIGHT}
      modal={false}
    >
      <revealer revealChild={revealer} transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}>
        <box class="slide-box">
          <box orientation={Gtk.Orientation.VERTICAL} spacing={18} class="control-center-container">
            {/* PROFILE */}
            <box class="profile-container" spacing={50}>
              <image file="/home/wreana/.config/ags/icons/furina.png" pixelSize={80} />
              <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                <label class="username-class" halign={Gtk.Align.START} label={username} />
                <label class="uptime-class" halign={Gtk.Align.START} label={uptime} />
              </box>
            </box>

            {/* POWER */}
            <box class="power-row" spacing={20}>
              <button onClicked={() => exec(["bash", "-c", "shutdown now"])}>
                <label class="power-icon" label="" />
              </button>
              <button class="power-button" onClicked={() => exec(["bash", "-c", "reboot"])}>
                <label class="power-icon" label="" />
              </button>
              <button class="power-button" onClicked={() => exec(["bash", "-c", "systemctl suspend"])}>
                <label class="power-icon" label="" />
              </button>
              <button
                class="power-button"
                onClicked={() =>
                  exec(["bash", "-c", "swaylock-fancy -e -K -p 10 -f Hack-Regular"])
                }
              >
                <label class="lock-power-icon" label="" />
              </button>
            </box>

            {/* TRAY */}
            <box class="tray-container-row" spacing={50}>
              <button class="power-button" onClicked={() => exec(["bash", "-c", "nmcli"])}>
                <label class="wifi-icon" label="󰤨" />
              </button>
              <button class="power-button" onClicked={() => exec(["bash", "-c", "blueman-manager"])}>
                <label class="wifi-icon" label="󰂯" />
              </button>
              <button
                class="power-button"
                onClicked={() =>
                  exec(["bash", "-c", "~/.config/Launcher/config-launcher.sh"])
                }
              >
                <label class="settings-icon" label="" />
              </button>
            </box>

            {/* SLIDERS */}
            <box class="tray-container-row" orientation={Gtk.Orientation.VERTICAL} spacing={20}>
              <box spacing={60}>
                <label class="brightness-icon" label="󰃠" />
                <slider
                  value={brightness((val) => val)}
                  cssClasses={["custom-slider"]}
                  min={0}
                  max={100}
                  widthRequest={150}
                  onChangeValue={({ value }) => {
                    const setValue = Math.trunc((value / 100) * rawMaxBrightness)
                    exec(["bash", "-c", `brightnessctl set ${setValue}`])
                  }}
                />
              </box>
              <box spacing={46}>
                <label class="brightness-icon" label="" />
                <slider
                  class="custom-slider"
                  value={volume((val) => val)}
                  min={0}
                  max={100}
                  widthRequest={150}
                  onChangeValue={({ value }) => {
                    exec(["bash", "-c", `pactl set-sink-volume @DEFAULT_SINK@ ${Math.trunc(value)}%`])
                  }}
                />
              </box>
            </box>
          </box>
        </box>
      </revealer>
    </window>
  )
}
