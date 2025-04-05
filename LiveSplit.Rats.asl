// Define the executable and variables
state("RATS") {
    int level :    "RATS.EXE", 0x1E86C;
    int mainMenu : "RATS.EXE", 0x1E888;
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
    if (false) {}
}

update {
    vars.gameStarted  = current.mainMenu == 0 && current.level == 0;

    if (timer.CurrentPhase == TimerPhase.Ended && settings.ResetEnabled && vars.gameStarted) {
        print("Restarting from main menu");
        vars.TimerModel.Reset();  // Reset `Ended` timer
    }
}
