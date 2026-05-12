fn processParticle(x: u32, y: u32, width: u32, height: u32) {
    // Ensure coordiantes are within grid bounds
    if (x >= width || x < 0 || y >= height || y < 0) {
        return;
    }

    // Retrieve 2x2 cell states
    let topLeft = getter(x, y, width, height);
    let topRight = getter(x+1, y, width, height);
    let bottomLeft = getter(x, y+1, width, height);
    let bottomRight = getter(x+1, y+1, width, height);

    // Apply sand rules if sand particle is present
    if (topLeft == SAND || topRight == SAND || bottomLeft == SAND || bottomRight == SAND) {
        sandBehaviour(x, y, width, height);
    }

    // Apply water rules if water particle is present
    if (
        topLeft == WATER || topRight == WATER || bottomLeft == WATER || bottomRight == WATER ||
        topLeft == WATERL || topRight == WATERL || bottomLeft == WATERL || bottomRight == WATERL ||
        topLeft == WATERR || topRight == WATERR || bottomLeft == WATERR || bottomRight == WATERR
    ) {
        waterBehaviour(x, y, width, height);
    }
}