@group(0) @binding(0) var<uniform> resolution : vec2<u32>;
@group(0) @binding(1) var<uniform> gridsize : vec2<u32>;
@group(0) @binding(2) var<uniform> mousepos: vec2<u32>;  // Mouse position (normalized to grid size)
@group(0) @binding(3) var<uniform> radius: f32;          // Radius of the spawn area
@group(0) @binding(4) var<storage, read> grid : array<u32>;

#include "./include/ids.wgsl"

@fragment
fn main(@builtin(position) fragCoord: vec4<f32>) -> @location(0) vec4<f32> {
    // Screen and grid aspect ratios
    let screenAspect = f32(resolution.x) / f32(resolution.y);
    let gridAspect = f32(gridsize.x) / f32(gridsize.y);

    // Determine scaling and offsets to center the grid
    var scale: vec2<f32>;
    var offset: vec2<f32>;

    if (screenAspect > gridAspect) {
        // Fit to height
        scale = vec2<f32>(gridAspect / screenAspect, 1.0);
        offset = vec2<f32>((1.0 - scale.x) * 0.5, 0.0);
    } else {
        // Fit to width
        scale = vec2<f32>(1.0, screenAspect / gridAspect);
        offset = vec2<f32>(0.0, (1.0 - scale.y) * 0.5);
    }

    // Normalize fragment coordinates to UV space
    let uv = fragCoord.xy / vec2<f32>(resolution);
    let gridUV = (uv - offset) / scale;

    // Check if the UV falls outside the grid
    if (gridUV.x < 0.0 || gridUV.x > 1.0 || gridUV.y < 0.0 || gridUV.y > 1.0) {
        // Render outside grid bounds as black
        return vec4<f32>(0.0, 0.0, 0.0, 1.0);
    }

    // Convert gridUV to grid cell coordinates (indices)
    let gridX = u32(gridUV.x * f32(gridsize.x));
    let gridY = u32(gridUV.y * f32(gridsize.y));

    // Calculate the 1D index for the grid (since grid is a flat array)
    let index = gridY * gridsize.x + gridX;

    // Fetch the grid value (you can convert this to a color or use as needed)
    let cellType = grid[index];

    // Distance from the mouse position
    let dx = f32(gridX) - f32(mousepos.x);
    let dy = f32(gridY) - f32(mousepos.y);
    let dist = sqrt(dx * dx + dy * dy);

    // If within the radius, render a white circle
    if(mousepos.x >= 0 && mousepos.x < gridsize.x && mousepos.y >= 0 && mousepos.y < gridsize.y) {
        if (dist <= radius && dist > radius-1) {
            return vec4<f32>(1.0, 1.0, 1.0, 1.0);  // White color
        }
    }

    // Choose color based on the cell type
    if (cellType == SAND) {
        return vec4<f32>(0.93, 0.79, 0.69, 1.0);  // Yellow for SAND
    } else if (cellType == WATER /*|| cellType == WATERL || cellType == WATERR*/) {
        return vec4<f32>(0.0, 0.0, 1.0, 1.0);  // Blue for WATER
    } else if(cellType == WATERL) {
        return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    } else if(cellType == WATERR) {
        return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    }

    // Output grid UV as color (black for empty cells)
    return vec4<f32>(0.0, 0.0, 0.0, 1.0);
}
