
import app from 'ags/gtk4/app';
import { networkActions } from '../widget/Networking';


export function toggleNetworkMenu() {
  const win = app.get_window("networkmenu");

  if (win) {
    if (win.visible) {
      win.hide();
    } else {
      networkActions.refresh();
      win.present();
    }
  } else {
    print("Error: Network menu window not found.");
  }
}
