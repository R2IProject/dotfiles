import app from "ags/gtk4/app"
import style from "./style.scss"
import ControlCenter from "./widget/ControlCenter"
import NetworkController from "./widget/Networking"

app.start({
  css: style,
  main() {
    app.get_monitors().forEach(monitor => {
      ControlCenter(monitor)
      NetworkController(monitor)
    })
  },
})
