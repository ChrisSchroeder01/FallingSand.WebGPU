fn empty(x: u32, y: u32, width: u32, height: u32) -> bool {
    return getter(x, y, width, height) == EMPTY && getter(x+1, y, width, height) == EMPTY && getter(x, y+1, width, height) == EMPTY && getter(x+1, y+1, width, height) == EMPTY;
}

// Goes around in the horizontal axis to find the closes 'slope' down
fn closestWayDown(x: u32, y: u32, width: u32, height: u32) -> i32 {
    var canMoveLeft = true;
    var canMoveRight = true;

    for (var offset = 1u; offset < width; offset = offset + 1u) {
        let currentLIndex = (width + x - offset) % width;
        if (canMoveLeft && getter(currentLIndex, y, width, height) == EMPTY) {
            if (getter(currentLIndex, y + 1u, width, height) == EMPTY) {
                return -i32(currentLIndex);
            }
        }

        if (canMoveLeft && getter(currentLIndex, y, width, height) != EMPTY) {
            canMoveLeft = false;
        }

        let currentRIndex = (x + offset) % width;
        if (canMoveRight && getter(currentRIndex, y, width, height) == EMPTY) {
            if (getter(currentRIndex, y + 1u, width, height) == EMPTY) {
                return i32(currentRIndex);
            }
        }

        if (canMoveRight && getter(currentRIndex, y, width, height) != EMPTY) {
            canMoveRight = false;
        }

        if (!canMoveLeft && !canMoveRight) {
            break;
        }
    }

    return 0;
}

// The water rules
fn waterBehaviour(x: u32, y: u32, width: u32, height: u32) {
    // Retrieve cell states
    let topLeft = getter(x, y, width, height);
    let topRight = getter(x+1, y, width, height);
    let bottomLeft = getter(x, y+1, width, height);
    let bottomRight = getter(x+1, y+1, width, height);

    // Rule 1: Water falling straight down
    if (topLeft == WATER && bottomLeft == EMPTY) {
        setter(x, y, width, height, EMPTY);
        setter(x, y+1, width, height, WATER);
        return;
    }

    if (topRight == WATER && bottomRight == EMPTY) {
        setter(x+1, y, width, height, EMPTY);
        setter(x+1, y+1, width, height, WATER);
        return;
    }

    // Rule 2: Water moves diagonally downwards when possible
    if (topLeft == WATER && bottomLeft != EMPTY && bottomRight == EMPTY && topRight == EMPTY) {
        setter(x, y, width, height, EMPTY);
        setter(x+1, y+1, width, height, WATER);
        return;
    }

    if (topRight == WATER && bottomRight != EMPTY && bottomLeft == EMPTY && topLeft == EMPTY) {
        setter(x+1, y, width, height, EMPTY);
        setter(x, y+1, width, height, WATER);
        return;
    }

    // Rule 3: Search horizontally for the nearest empty space below
    if (topLeft == WATER && topRight == EMPTY && bottomLeft != EMPTY && bottomRight != EMPTY) {
        if(closestWayDown(x, y, width, height) > 0) {
            setter(x, y, width, height, EMPTY);
            setter(x+1, y, width, height, WATER);
            return;
        }
    }

    if (topLeft == EMPTY && topRight == WATER && bottomLeft != EMPTY && bottomRight != EMPTY) {
        if(closestWayDown(x+1, y, width, height) < 0) {
            setter(x+1, y, width, height, EMPTY);
            setter(x, y, width, height, WATER);
            return;
        }
    }

    if (topLeft == EMPTY && topRight == EMPTY && bottomLeft == WATER && bottomRight == EMPTY) {
        if(closestWayDown(x, y+1, width, height) > 0) {
            setter(x, y+1, width, height, EMPTY);
            setter(x+1, y+1, width, height, WATER);
            return;
        }
    }

    if (topLeft == EMPTY && topRight == EMPTY && bottomLeft == EMPTY && bottomRight == WATER) {
        if(closestWayDown(x+1, y+1, width, height) < 0) {
            setter(x+1, y+1, width, height, EMPTY);
            setter(x, y+1, width, height, WATER);
            return;
        }
    }
}
