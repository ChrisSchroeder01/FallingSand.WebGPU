// The sand rules
fn sandBehaviour(x: u32, y: u32, width: u32, height: u32) {
    // Retrieve cell states
    let topLeft = getter(x, y, width, height);
    let topRight = getter(x+1, y, width, height);
    let bottomLeft = getter(x, y+1, width, height);
    let bottomRight = getter(x+1, y+1, width, height);

    // Apply sand rules for top-left sand falling straight down
    if (topLeft == SAND && bottomLeft == EMPTY) {
        setter(x, y, width, height, EMPTY);
        setter(x, y+1, width, height, SAND);
        return;
    }

    // Apply sand rules for top-right sand falling straight down
    if (topRight == SAND && bottomRight == EMPTY) {
        setter(x+1, y, width, height, EMPTY);
        setter(x+1, y+1, width, height, SAND);
        return;
    }

    // Apply sand rules for top-left sand falling diagonally right
    if (topLeft == SAND && bottomRight == EMPTY && topRight == EMPTY) {
        setter(x, y, width, height, EMPTY);
        setter(x+1, y+1, width, height, SAND);
        return;
    }

    // Apply sand rules for top-right sand falling diagonally left
    if (topRight == SAND && bottomLeft == EMPTY && topLeft == EMPTY) {
        setter(x+1, y, width, height, EMPTY);
        setter(x, y+1, width, height, SAND);
        return;
    }
}
