var ap_settings = gui.Dialog.new("/sim/gui/dialogs/autopilot/dialog",
        "Aircraft/737-400/Dialogs/737-ap-dialog.xml");
var radio = gui.Dialog.new("/sim/gui/dialogs/radios/dialog",
        "Aircraft/737-400/Dialogs/737-radio-dialog.xml");
				
gui.menuBind("autopilot-settings", "dialogs.ap_settings.open()");
gui.menuBind("radio", "dialogs.radio.open()");