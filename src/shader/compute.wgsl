@group(0) @binding(0) var<uniform> gridsize : vec2<u32>; // Grid size (width, height)
@group(0) @binding(1) var<uniform> shiftmode : u32;      // Shift mode (0 or 1)
@group(0) @binding(2) var<storage, read_write> grid : array<u32>; // The grid buffer

#include "./include/ids.wgsl"
#include "./include/random.wgsl"
#include "./include/getset.wgsl"

#include "./include/sandBehaviour.wgsl"
#include "./include/waterBehaviour.wgsl"
#include "./include/processParticle.wgsl"

@compute @workgroup_size(8, 8, 1) // Workgroup size is 8x8
fn main(@builtin(global_invocation_id) global_id : vec3<u32>) {
    // Reduced grid dimensions (2x2 blocks)
    let reduced_width = gridsize.x / 2;
    let reduced_height = gridsize.y / 2;

    // Ensure we are within bounds of the reduced grid
    if (global_id.x >= reduced_width || global_id.y >= reduced_height) {
        return;
    }

    // Base coordinates in the original grid for the top-left cell of this 2x2 block
    var base_x = global_id.x * 2;
    var base_y = global_id.y * 2;

    // Apply diagonal shift if shiftmode is enabled
    if (shiftmode == 1u) {
        base_x = (base_x + 1) % gridsize.x; // Shift right with wrapping
        base_y = base_y + 1; // Shift down without wrapping
    }

    // Ensure vertical bounds are respected
    if (base_y >= gridsize.y - 1) {
        return; // Exit if the bottom row of this block is outside the grid
    }

    // Compute the indices for the 2x2 block with horizontal wrapping
    let index = (base_x + base_y * gridsize.x);                        // Top-left
    let index1 = ((base_x + 1) % gridsize.x + base_y * gridsize.x);    // Top-right
    let index2 = (base_x + (base_y + 1) * gridsize.x);                 // Bottom-left
    let index3 = ((base_x + 1) % gridsize.x + (base_y + 1) * gridsize.x); // Bottom-right

    let r = random(index);

    // Sand behavior for the 2x2 block
    processParticle(base_x, base_y, gridsize.x, gridsize.y);
}
