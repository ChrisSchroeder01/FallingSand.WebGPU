fn waterBehaviour(idx: u32, width: u32, height: u32) {
    let belowIdx = idx + width;

    // Water moves down if the cell below is empty
    if (belowIdx < width * height && grid[belowIdx] == EMPTY) {
        grid[idx] = EMPTY;
        grid[belowIdx] = WATER;
        return;
    }

    // Randomly try to move left or right if the cell below is blocked
    let leftIdx = idx - 1;
    let rightIdx = idx + 1;

    if (leftIdx % width < idx % width && grid[leftIdx] == EMPTY) {
        grid[idx] = EMPTY;
        grid[leftIdx] = WATER;
    } else if (rightIdx % width > idx % width && grid[rightIdx] == EMPTY) {
        grid[idx] = EMPTY;
        grid[rightIdx] = WATER;
    }
}
