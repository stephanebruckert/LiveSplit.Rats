
state("RATS", "2.0") {
    // Version from https://archive.org/details/swizzle_demu_RAT_201703, assuming v2.0
    int level :    0x1E86C;
    int mainMenu : 0x1E888;
}

state("Rats", "3.1a") {
    // Version from http://www.windowsgames.co.uk/rats.html
    int level :    0x19998;
    int mainMenu : 0x199B4;
}

init {
    var module = modules.First();
	var name = module.ModuleName;
	var size = module.ModuleMemorySize;

	print("Size = " + size);

    switch(size) {
		case 233472:
			version = "2.0";
			break;
		case 389120:
			version = "3.1a";
			break;
		default:
			version = "Unknown";
			var gameMessageText = "Unknown " + name + " " + size;
            var message = "It appears you're running an unknown/newer version of the game.\n"+
				"This ASL script might not work.\n\n"+
				"Please @1stance on the Rats! Speedrunning discord with "+
				"the following:\n" + gameMessageText + "\n\n"+
				"Press OK to copy the above info to the clipboard and close this message.";
            var dialog = MessageBox.Show(
				message,
                "Rats! ASL | LiveSplit",
				MessageBoxButtons.OKCancel,
                MessageBoxIcon.Warning
			);
            if (dialog == DialogResult.OK) {
                Clipboard.SetText(gameMessageText);
            }
			break;
	}
	print("Version = " + version);
}

startup {
    // Needed in `update` to reset an `Ended` timer
    vars.TimerModel = new TimerModel { CurrentState = timer };
}

start {
    if (vars.gameStarted) {
        print("New game");
        return true;
    }
}

split {
    if (current.level != old.level) {
        print("Split");
        return true;
    }

    if (current.mainMenu == 1) {
        print("Game Over");
        return true;
    }
}

reset {
    // Cannot be empty for auto-reset option to appear in LiveSplit config
    return false;
}

update {
    vars.gameStarted = current.mainMenu == 0 && old.mainMenu == 1 && current.level == 0;

    if (timer.CurrentPhase == TimerPhase.Ended && settings.ResetEnabled && vars.gameStarted) {
        print("Restarting from main menu");
        vars.TimerModel.Reset();  // Reset `Ended` timer
    }
}
