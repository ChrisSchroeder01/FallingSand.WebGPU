// Get the value from a grid buffer using x and y coordinates
fn getter(x: u32, y: u32, width: u32, height: u32) -> u32 {
    // Compute the linear index
    let index: u32 = y * width + x;
    // Return the value at the computed index
    return grid[index];
}

// Set a value in the grid buffer using x and y coordinates
fn setter(x: u32, y: u32, width: u32, height: u32, value: u32) {
    // Compute the linear index
    let index: u32 = y * width + x;
    // Set the value at the computed index
    grid[index] = value;
}
