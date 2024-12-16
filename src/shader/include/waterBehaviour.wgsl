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

    // Rule 2: Water moves horizontally if at least one cell below is not empty
    if (topLeft == WATER && topRight == EMPTY && (bottomLeft != EMPTY && bottomRight != EMPTY)) {
        let direction = random(index); // Generate a random value
        if (direction > 0.5) {
            grid[index] = EMPTY;
            grid[index1] = WATER;
        }
        return;
    }

    if (topRight == WATER && topLeft == EMPTY && (bottomLeft != EMPTY && bottomRight != EMPTY)) {
        let direction = random(index); // Generate a random value
        if (direction > 0.5) {
            grid[index1] = EMPTY;
            grid[index] = WATER;
        }
        return;
    }

    if (bottomLeft == WATER && bottomRight == EMPTY && topLeft == EMPTY && topRight == EMPTY)
    {
        let direction = random(index); // Generate a random value
        if (direction > 0.5) {
            grid[index2] = EMPTY;
            grid[index3] = WATER;
        }
        return;
    }

    if (bottomRight == WATER && bottomLeft == EMPTY && topLeft == EMPTY && topRight == EMPTY)
    {
        let direction = random(index); // Generate a random value
        if (direction > 0.5) {
            grid[index3] = EMPTY;
            grid[index2] = WATER;
        }
        return;
    }

    // Rule 3: Water moves diagonally downwards when possible
    if (topLeft == WATER && bottomLeft != EMPTY && bottomRight == EMPTY && topRight == EMPTY) {
        grid[index] = EMPTY;
        grid[index3] = WATER;
        return;
    }

    if (topRight == WATER && bottomRight != EMPTY && bottomLeft == EMPTY && topLeft == EMPTY) {
        grid[index1] = EMPTY;
        grid[index2] = WATER;
        return;
    }
}
