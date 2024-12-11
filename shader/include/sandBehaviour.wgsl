fn sandBehaviour(idx: u32, width: u32, height: u32) {
    // Calculate the row and column of the current cell
    let row = idx / width;
    let col = idx % width;

    // Calculate indices for downward, downward-left, and downward-right movements
    let belowIdx = idx + width;
    let belowLeftIdx = (row + 1) * width + ((col + width - 1) % width); // Wrap around left
    let belowRightIdx = (row + 1) * width + ((col + 1) % width); // Wrap around right

    // Check if the cell is at the bottom of the grid
    if (row + 1 >= height) {
        return; // Stay stationary at the bottom
    }

    // If the cell below is empty, move down
    if (grid[belowIdx] == EMPTY) {
        grid[idx] = EMPTY;
        grid[belowIdx] = SAND;
        return;
    }

    if(grid[belowLeftIdx] == EMPTY && grid[belowRightIdx] == EMPTY)
    {
        let i = random();
        grid[idx] = EMPTY;
        if(i > 0.5){
            grid[belowLeftIdx] = SAND;
            return;
        }
        grid[belowRightIdx] = SAND;
        return;
    }

    // If the cell below and to the left is empty, move down and left
    if (grid[belowLeftIdx] == EMPTY) {
        grid[idx] = EMPTY;
        grid[belowLeftIdx] = SAND;
        return;
    }

    // If the cell below and to the right is empty, move down and right
    if (grid[belowRightIdx] == EMPTY) {
        grid[idx] = EMPTY;
        grid[belowRightIdx] = SAND;
        return;
    }

    // Otherwise, stay stationary
}
