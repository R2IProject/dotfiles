import app from "ags/gtk4/app"
import { Gtk, Gdk, Astal } from "ags/gtk4"
import { exec, execAsync } from "ags/process"

const NetworkActions = {
  refresh: () => { },
  rescan: () => { },
  toggleWifi: (_: boolean) => { },
  passwordWindow: null as (Gtk.Window | null),
  pendingSSID: null as (string | null),
}
export const networkActions = NetworkActions;
export default function NetworkController(monitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor

  function createPasswordWindow(
    monitor: Gdk.Monitor,
    onSubmit: (password: string) => void
  ) {
    const entry = new Gtk.Entry({
      visibility: false,
      placeholder_text: "Password",
    })

    const win = new Gtk.Window({
      application: app,
      name: "wifipassword",
      modal: true,
      visible: false,
    })
    const content = new Gtk.Box({
      orientation: Gtk.Orientation.VERTICAL,
      spacing: 8,
      margin_top: 12,
      margin_bottom: 12,
      margin_start: 12,
      margin_end: 12,
      name: "wifi-password-box"
    })

    content.append(new Gtk.Label({ label: "Wi-Fi Password", name: "wifi-password-label" }))
    content.append(entry)

    const btnBox = new Gtk.Box({
      orientation: Gtk.Orientation.HORIZONTAL,
      spacing: 6,
    })

    const cancelBtn = new Gtk.Button({ label: "Cancel", name: "wifi-cancel-button" })
    cancelBtn.connect("clicked", () => win.hide())

    const connectBtn = new Gtk.Button({ label: "Connect", name: "wifi-connect-button" })
    connectBtn.connect("clicked", () => {
      onSubmit(entry.text)
      entry.text = ""
      win.hide()
    })

    btnBox.append(cancelBtn)
    btnBox.append(new Gtk.Box({ hexpand: true }))
    btnBox.append(connectBtn)

    content.append(btnBox)
    win.set_child(content)
    return win
  }

  const list = new Gtk.Box({
    orientation: Gtk.Orientation.VERTICAL,
    spacing: 6,
  })

  function clearList() {
    let child = list.get_first_child()
    while (child) {
      list.remove(child)
      child = list.get_first_child()
    }
  }

  async function getSavedConnections() {
    try {
      const out = await execAsync([
        "bash",
        "-c",
        "nmcli -t -f NAME,DEVICE connection show",
      ])
      return new Set(out.trim().split("\n").map(line => line.split(":")[0]))
    } catch (e) {
      print(`Error fetching connections: ${e}`)
      return new Set()
    }
  }

  async function refresh() {
    clearList()
    const savedConnections = await getSavedConnections()

    const out = exec([
      "bash",
      "-c",
      "nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list",
    ]).trim()

    if (!out) return

    for (const line of out.split("\n")) {
      const [use, ssid, signal, security] = line.split(":")
      if (!ssid) continue

      const connected = use === "*"
      const saved = savedConnections.has(ssid)
      const secure = security && security !== "--"
      const needsPassword = secure && !connected && !saved

      const row = new Gtk.Box({
        orientation: Gtk.Orientation.HORIZONTAL,
        spacing: 6,
        name: "wifi-row"
      })

      row.append(
        new Gtk.Label({
          xalign: 0,
          // Use a safe fallback for the icon if the glyph isn't loaded
          label: `${connected ? "󰤨" : "󰤮"} ${ssid} (${signal}%)`,
          name: "wifi-ssid-label"
        }),
      )

      row.append(new Gtk.Box({ hexpand: true }))

      const connectBtn = new Gtk.Button({
        label: connected ? "Disconnect" : "Connect",
        name: connected ? "wifi-disconnect-button" : (saved ? "wifi-connect-saved-button" : "wifi-connect-new-button")
      })

      connectBtn.connect("clicked", () => {
        if (connected) {
          execAsync(["nmcli", "device", "disconnect", "wlan0"])
        } else if (needsPassword) {
          NetworkActions.pendingSSID = ssid
          NetworkActions.passwordWindow?.show()
        } else {
          execAsync([
            "nmcli",
            "connection",
            "up",
            ssid,
          ])
        }

        setTimeout(NetworkActions.refresh, 1200)
      })
      const forgetBtn = new Gtk.Button({
        label: "Forget",
        name: "wifi-forget-button"
      })

      forgetBtn.connect("clicked", () => {
        execAsync([
          "bash",
          "-c",
          `nmcli connection delete ${ssid}`,
        ])
        setTimeout(NetworkActions.refresh, 1200)
      })

      row.append(connectBtn)
      if (saved) row.append(forgetBtn)
      list.append(row)
    }
  }

  function rescan() {
    clearList()
    execAsync(["nmcli", "device", "wifi", "rescan"])
    setTimeout(NetworkActions.refresh, 1500)
  }

  function toggleWifi(enable: boolean) {
    execAsync(["nmcli", "radio", "wifi", enable ? "on" : "off"])
    setTimeout(NetworkActions.refresh, 1200)
  }

  NetworkActions.refresh = refresh
  NetworkActions.rescan = rescan
  NetworkActions.toggleWifi = toggleWifi

  NetworkActions.passwordWindow = createPasswordWindow(monitor, (password) => {
    if (!NetworkActions.pendingSSID) return

    const ssid = NetworkActions.pendingSSID
    NetworkActions.pendingSSID = null

    execAsync([
      "nmcli",
      "device",
      "wifi",
      "connect",
      ssid,
      "password",
      password,
      "name",
      ssid,
    ])
      .then(() => {
        setTimeout(NetworkActions.refresh, 2000)
      })
      .catch((err) => {
        print(`Failed to connect: ${err}`)
      })
  })

  return (
    <window
      name="networkmenu"
      application={app}
      gdkmonitor={monitor}
      anchor={TOP | RIGHT}
      visible={false}
      class="FloatingWindow"
    >
      <box
        orientation={Gtk.Orientation.VERTICAL}
        spacing={10}
        class="network-menu-shell"
      >

        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={6}
          class="network-menu-block network-menu-controls"
        >
          <box spacing={6} name="network-controls-row">
            <label label="Wi-Fi" name="wifi-header-label" />
            <box hexpand />
            <button label="Rescan" onClicked={NetworkActions.rescan} name="rescan-button" />
            <button label="On" onClicked={() => NetworkActions.toggleWifi(true)} name="toggle-on-button" />
            <button label="Off" onClicked={() => NetworkActions.toggleWifi(false)} name="toggle-off-button" />
          </box>
        </box>


        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={6}
          class="network-menu-block network-menu-list"
        >
          {list}
        </box>
      </box>
    </window>
  )
}
