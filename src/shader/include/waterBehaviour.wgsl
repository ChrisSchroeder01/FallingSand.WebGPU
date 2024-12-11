fn waterBehaviour(index: u32, index1: u32, index2: u32, index3: u32, width: u32, height: u32) {
    // Ensure indices are within grid bounds
    if (index >= width * height || index1 >= width * height || index2 >= width * height || index3 >= width * height) {
        return;
    }

    // Retrieve cell states
    let topLeft = grid[index];
    let topRight = grid[index1];
    let bottomLeft = grid[index2];
    let bottomRight = grid[index3];

    // Rule 1: Water falling straight down
    if (topLeft == WATER && bottomLeft == EMPTY) {
        grid[index] = EMPTY;
        grid[index2] = WATER;
        return;
    }

    if (topRight == WATER && bottomRight == EMPTY) {
        grid[index1] = EMPTY;
        grid[index3] = WATER;
        return;
    }

    // Rule 2: Water moves horizontally if both cells below are water or sand
    if (topLeft == WATER && (bottomLeft == WATER || bottomLeft == SAND) && (bottomRight == WATER || bottomRight == SAND)) {
        // Use random to determine if the water moves to the left or right
        let direction = random(index); // Generate a random value

        // If random() decides to move right (e.g., > 0.5), move right
        if (direction > 0.5 && topRight == EMPTY) {
            grid[index] = EMPTY;
            grid[index1] = WATER;
            return;
        }
        // Otherwise, move left
        if (topLeft == EMPTY) {
            grid[index] = EMPTY;
            grid[index2] = WATER;
            return;
        }
    }

    // Rule 3: Water moves diagonally downwards when possible
    if (topLeft == WATER && bottomRight == EMPTY && topRight == EMPTY) {
        grid[index] = EMPTY;
        grid[index3] = WATER;
        return;
    }

    if (topRight == WATER && bottomLeft == EMPTY && topLeft == EMPTY) {
        grid[index1] = EMPTY;
        grid[index2] = WATER;
        return;
    }
}
