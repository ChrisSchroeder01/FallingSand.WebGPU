
@group(0) @binding(40) var<storage, read_write> state: u32;

fn xorshift32(seed: u32) -> u32 {
    var x = seed;
    x ^= x << 21;
    x ^= x >> 17;
    x ^= x << 4;
    return x * 4294967295;
}

fn random() -> f32 {
    let random_value = xorshift32(state);
    state = random_value; // update the seed
    return f32(random_value) / 4294967295.0;
}