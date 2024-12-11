fn processParticle(index: u32, index1: u32, index2: u32, index3: u32, width: u32, height: u32) {
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
    if (topLeft == SAND || topRight == SAND || bottomLeft == SAND || bottomRight == SAND) {
        sandBehaviour(index, index1, index2, index3, width, height);
    }

    if (topLeft == WATER || topRight == WATER || bottomLeft == WATER || bottomRight == WATER) {
        waterBehaviour(index, index1, index2, index3, width, height);
    }
}
