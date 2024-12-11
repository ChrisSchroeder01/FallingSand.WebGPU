fn sandBehaviour(index: u32, index1: u32, index2: u32, index3: u32, width: u32, height: u32) {
    // Ensure indices are within grid bounds
    if (index >= width * height || index1 >= width * height || index2 >= width * height || index3 >= width * height) {
        return;
    }

    // Retrieve cell states
    let topLeft = grid[index];
    let topRight = grid[index1];
    let bottomLeft = grid[index2];
    let bottomRight = grid[index3];

    // Apply sand rules for top-left sand falling straight down
    if (topLeft == SAND && bottomLeft == EMPTY) {
        grid[index] = EMPTY;
        grid[index2] = SAND;
        return;
    }

    // Apply sand rules for top-right sand falling straight down
    if (topRight == SAND && bottomRight == EMPTY) {
        grid[index1] = EMPTY;
        grid[index3] = SAND;
        return;
    }

    // Apply sand rules for top-left sand falling diagonally right
    if (topLeft == SAND && bottomRight == EMPTY && topRight == EMPTY) {
        grid[index] = EMPTY;
        grid[index3] = SAND;
        return;
    }

    // Apply sand rules for top-right sand falling diagonally left
    if (topRight == SAND && bottomLeft == EMPTY && topLeft == EMPTY) {
        grid[index1] = EMPTY;
        grid[index2] = SAND;
        return;
    }
}
