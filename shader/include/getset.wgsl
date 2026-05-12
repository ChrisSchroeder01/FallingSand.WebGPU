// Get the value from the grid buffer using x and y coordinates
fn getter(x: u32, y: u32, width: u32, height: u32) -> u32 {
    let index: u32 = y * width + x;
    return grid[index];
}

// Set the value in the grid buffer using x and y coordinates
fn setter(x: u32, y: u32, width: u32, height: u32, value: u32) {
    let index: u32 = y * width + x;
    grid[index] = value;
}
