@group(0) @binding(0) var<uniform> gridsize: vec2<u32>;         // Grid size (e.g., [64, 64])
@group(0) @binding(1) var<uniform> mousepos: vec2<u32>;         // Mouse position (normalized to grid size)
@group(0) @binding(2) var<uniform> radius: f32;                 // Radius of the spawn area
@group(0) @binding(3) var<uniform> particle: u32;
@group(0) @binding(4) var<storage, read_write> grid: array<u32>;

#include "./include/ids.wgsl"

@compute @workgroup_size(8, 8, 1)
fn main(@builtin(global_invocation_id) global_id : vec3<u32>) {
    // Get the current grid position
    let width = gridsize.x;
    let height = gridsize.y;

    // Calculate the index into the grid (flattened 1D index from 2D grid)
    let index = global_id.x + global_id.y * width;

    // Ensure we are within bounds of the grid
    if (global_id.x >= width || global_id.y >= height) {
        return;
    }

    // Calculate distance from the mouse position
    let dx = f32(global_id.x) - f32(mousepos.x);
    let dy = f32(global_id.y) - f32(mousepos.y);
    let dist = sqrt(dx * dx + dy * dy);

    // If within the radius, set the grid cell to a particle type (e.g., SAND)
    if (dist <= radius) {
        if(grid[index] == EMPTY || particle == EMPTY) {
            grid[index] = particle;  // Set the grid cell to the specified particle type
        }
    }
}
