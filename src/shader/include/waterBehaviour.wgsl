fn empty(x: u32, y: u32, width: u32, height: u32) -> bool {
    return getter(x, y, width, height) == EMPTY && getter(x+1, y, width, height) == EMPTY && getter(x, y+1, width, height) == EMPTY && getter(x+1, y+1, width, height) == EMPTY;
}

fn closestWayDown(x: u32, y: u32, width: u32, height: u32) -> i32 {
    var canMoveLeft = true;
    var canMoveRight = true;

    for (var offset = 1u; offset < width; offset = offset + 1u) {
        // Wrap-around left
        let currentLIndex = (width + x - offset) % width;
        if (canMoveLeft && getter(currentLIndex, y, width, height) == EMPTY) {
            if (getter(currentLIndex, y + 1u, width, height) == EMPTY) {
                return -i32(currentLIndex);
            }
        }
        if (canMoveLeft && getter(currentLIndex, y, width, height) != EMPTY) {
            canMoveLeft = false;
        }

        // Wrap-around right
        let currentRIndex = (x + offset) % width;
        if (canMoveRight && getter(currentRIndex, y, width, height) == EMPTY) {
            if (getter(currentRIndex, y + 1u, width, height) == EMPTY) {
                return i32(currentRIndex);
            }
        }
        if (canMoveRight && getter(currentRIndex, y, width, height) != EMPTY) {
            canMoveRight = false;
        }

        // If both directions are blocked, stop early
        if (!canMoveLeft && !canMoveRight) {
            break;
        }
    }

    return 0;
}

fn waterBehaviour(x: u32, y: u32, width: u32, height: u32) {
    // Retrieve cell states using a getter function
    let topLeft = getter(x, y, width, height);               // Get top-left
    let topRight = getter(x+1, y, width, height);             // Get top-right
    let bottomLeft = getter(x, y+1, width, height);           // Get bottom-left
    let bottomRight = getter(x+1, y+1, width, height);        // Get bottom-right

    // Rule 1: Water falling straight down
    if (topLeft == WATER && bottomLeft == EMPTY) {
        setter(x, y, width, height, EMPTY);           // Set top-left to empty
        setter(x, y+1, width, height, WATER);         // Set bottom-left to water
        return;
    }

    if (topRight == WATER && bottomRight == EMPTY) {
        setter(x+1, y, width, height, EMPTY);         // Set top-right to empty
        setter(x+1, y+1, width, height, WATER);       // Set bottom-right to water
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

    // Special handling for bottom-left and bottom-right cases
    if (topLeft == WATER && topRight == EMPTY && bottomLeft != EMPTY && bottomRight == EMPTY) {
        let bottomRightIndex = x + width + 1;  // Calculate bottom-right index
        if (getter(bottomRightIndex, y+1, width, height) == EMPTY) {
            setter(x, y, width, height, EMPTY);
            setter(bottomRightIndex, y+1, width, height, WATER);
            return;
        }
    }

    if (topLeft == WATER && topRight == EMPTY && bottomLeft == EMPTY && bottomRight != EMPTY) {
        let bottomLeftIndex = x + width - 1;  // Calculate bottom-left index
        if (getter(bottomLeftIndex, y+1, width, height) == EMPTY) {
            setter(x, y, width, height, EMPTY);
            setter(bottomLeftIndex, y+1, width, height, WATER);
            return;
        }
    }

    if (topLeft == WATER && topRight == EMPTY && bottomLeft == EMPTY && bottomRight == EMPTY) {
        let bottomLeftIndex = x + width - 1;
        let bottomRightIndex = x + width + 1;

        // Prefer bottom-left if both are open
        if (getter(bottomLeftIndex, y+1, width, height) == EMPTY) {
            setter(x, y, width, height, EMPTY);
            setter(bottomLeftIndex, y+1, width, height, WATER);
            return;
        } else if (getter(bottomRightIndex, y+1, width, height) == EMPTY) {
            setter(x, y, width, height, EMPTY);
            setter(bottomRightIndex, y+1, width, height, WATER);
            return;
        }
    }
}
