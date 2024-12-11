@group(0) @binding(0) var<uniform> gridsize : vec2<u32>; // Grid size (width, height)
@group(0) @binding(1) var<storage, read_write> grid : array<u32>; // The grid buffer

#include "./include/ids.wgsl"

#include "./include/random.wgsl"

#include "./include/sandBehaviour.wgsl"
#include "./include/waterBehaviour.wgsl"



@compute @workgroup_size(8, 8, 1) // Workgroup size is 8x8
fn main(@builtin(global_invocation_id) global_id : vec3<u32>) {

    // Grid size
    let width = gridsize.x;
    let height = gridsize.y;

    // Calculate the index into the grid (flattened 1D index from 2D grid)
    let index = global_id.x + global_id.y * width;

    // Ensure we are within bounds of the grid
    if (global_id.x >= width || global_id.y >= height) {
        return;
    }

    let r = random();

    // Retrieve the type of the current cell
    let cellType = grid[index];

    // Call the behavior function based on the cell type
    if (cellType == SAND) {
        sandBehaviour(index, width, height);
    } else if (cellType == WATER) {
        waterBehaviour(index, width, height);
    }
}
