import { fetchShader, include } from './src/ShaderUtils.js';
import Material from './src/Material.js';
import Compute from './src/Compute.js';

class Main {
    constructor() {
        this.canvas = document.querySelector('canvas');
        this.gridSize = { x: 512, y: 512 };
        this.gridCoord = { x: 0, y: 0 };
        this.radius = 1;
        this.mouseDown = false;
        this.mouseRight = false;
        this.selected = 1;
        this.shiftMode = 0;
    }

    async initialize() {
        if (!navigator.gpu) {
            console.error("WebGPU not supported on this browser.");
            return;
        }

        const adapter = await navigator.gpu.requestAdapter();
        const device = await adapter.requestDevice();
        const context = this.canvas.getContext('webgpu');
        const format = navigator.gpu.getPreferredCanvasFormat();

        context.configure({
            device,
            format,
            alphaMode: 'opaque',
        });

        this.device = device;
        this.context = context;
        this.format = format;

        await this.setupShaders();
        this.createBuffers();
        this.createMaterial();
        this.createComputeShader();
        this.setupEventListeners();
        this.resize();
        this.loop();
    }

    async setupShaders() {
        this.vertexShaderCode = await fetchShader('./src/shader/vertex.wgsl');
        this.fragmentShaderCode = await include('./src/shader/fragment.wgsl');
        this.computeShaderCode = await include('./src/shader/compute.wgsl');
        this.computePlaceShaderCode = await include('./src/shader/computePlace.wgsl');
    }

    createBuffers() {
        const gridBufferSize = this.gridSize.x * this.gridSize.y * 4;
        const alignedGridBufferSize = Math.ceil(gridBufferSize / 256) * 256;

        this.gridBuffer = this.device.createBuffer({
            size: alignedGridBufferSize,
            usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_SRC | GPUBufferUsage.COPY_DST,
        });

        this.initialGrid = new Uint32Array(this.gridSize.x * this.gridSize.y);
        //for (let i = 0; i < this.gridSize.x * this.gridSize.y; i++) {
        //    this.initialGrid[i] = Math.random() > 0.95 ? 1 : 0;
        //}

        this.device.queue.writeBuffer(this.gridBuffer, 0, this.initialGrid);
    }

    createMaterial() {
        this.material = new Material(this.device, this.vertexShaderCode, this.fragmentShaderCode, {
            0: { size: 8, usage: GPUBufferUsage.UNIFORM },
            1: { size: 8, usage: GPUBufferUsage.UNIFORM },
            2: { size: 8, usage: GPUBufferUsage.UNIFORM },
            3: { size: 4, usage: GPUBufferUsage.UNIFORM },
        }, {
            4: this.gridBuffer,
        });

        this.material.createPipeline(this.format);
    }

    createComputeShader() {
        this.compute = new Compute(this.device, this.computeShaderCode, {
            0: { size: 8, usage: GPUBufferUsage.UNIFORM },
            1: { size: 4, usage: GPUBufferUsage.UNIFORM },
        }, {
            2: this.gridBuffer,
            40: this.device.createBuffer({size: 4, usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_SRC | GPUBufferUsage.COPY_DST})
        });

        this.compute.createPipeline();
        this.compute.updateUniform('0', new Uint32Array([this.gridSize.x, this.gridSize.y]));


        this.computePlace = new Compute(this.device, this.computePlaceShaderCode, {
            0: { size: 8, usage: GPUBufferUsage.UNIFORM },
            1: { size: 8, usage: GPUBufferUsage.UNIFORM },
            2: { size: 4, usage: GPUBufferUsage.UNIFORM },
            3: { size: 4, usage: GPUBufferUsage.UNIFORM },
        }, {
            4: this.gridBuffer,
        });
        this.computePlace.createPipeline();
        this.computePlace.updateUniform('0', new Uint32Array([this.gridSize.x, this.gridSize.y]));
    }

    setupEventListeners() {
        window.addEventListener('resize', () => this.resize());
        this.canvas.addEventListener('mousemove', (event) => this.onMouseMove(event));
        this.canvas.addEventListener("mousedown", (event) => this.onMouseDown(event));
        this.canvas.addEventListener("mouseup", (event) => this.onMouseUp(event));
        this.canvas.addEventListener("wheel", (event) => this.onWheel(event));

        const materialSelect = document.getElementById('material-select');
        materialSelect.addEventListener('change', (event) => {
        this.selected = parseInt(event.target.value, 10);
        console.log(`Selected material changed to: ${this.selected}`);
    });
    }

    resize() {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
        this.material.updateUniform('0', new Uint32Array([this.canvas.width, this.canvas.height]));
        this.material.updateUniform('1', new Uint32Array([this.gridSize.x, this.gridSize.y]));
        this.render();
    }

    onMouseMove(event) {
        const canvasRect = this.canvas.getBoundingClientRect();
        const screenWidth = canvasRect.width;
        const screenHeight = canvasRect.height;

        const screenAspect = screenWidth / screenHeight;
        const gridAspect = this.gridSize.x / this.gridSize.y;

        let scale = { x: 1.0, y: 1.0 };
        let offset = { x: 0.0, y: 0.0 };

        if (screenAspect > gridAspect) {
            scale.x = gridAspect / screenAspect;
            scale.y = 1.0;
            offset.x = (1.0 - scale.x) * 0.5;
        } else {
            scale.x = 1.0;
            scale.y = screenAspect / gridAspect;
            offset.y = (1.0 - scale.y) * 0.5;
        }

        const mouse = {x: event.clientX - canvasRect.left, y: event.clientY - canvasRect.top};

        let gridUV = {x: (mouse.x / screenWidth - offset.x) / scale.x, y: (mouse.y / screenHeight - offset.y) / scale.y};

        this.gridCoord = {x: Math.floor(gridUV.x * this.gridSize.x), y: Math.floor(gridUV.y * this.gridSize.y)};

        this.material.updateUniform('2', new Uint32Array([this.gridCoord.x, this.gridCoord.y]));
    }

    onMouseDown(event) {
        this.mouseDown = true
        if (event.button == 2) {
            this.mouseRight = true;
            return;
        }
        this.mouseRight = false;
    }

    onMouseUp(event) {
        this.mouseDown = false
    }

    onWheel(event) {
        this.radius = Math.min(Math.max(Math.floor(this.radius - event.deltaY / 100), 0), 20);
        this.material.updateUniform('3', new Float32Array([this.radius]));
        console.log(this.radius);
    }

    render() {
        const commandEncoder = this.device.createCommandEncoder();
        
        if (this.mouseDown) {
            this.computePlace.updateUniform(1, new Uint32Array([this.gridCoord.x, this.gridCoord.y]))
            this.computePlace.updateUniform(2, new Float32Array([this.radius]))
            this.computePlace.updateUniform(3, new Uint32Array([this.mouseRight ? 0 : this.selected]))

            this.computePlace.run(commandEncoder, Math.ceil(this.gridSize.x / 8), Math.ceil(this.gridSize.y / 8), 1);
        }

        this.compute.updateUniform(1, new Uint32Array([this.shiftMode]));
        this.shiftMode = 1 - this.shiftMode;

        this.compute.run(commandEncoder, Math.ceil(this.gridSize.x / 8 / 2), Math.ceil(this.gridSize.y / 8 / 2), 1);

        const textureView = this.context.getCurrentTexture().createView();
        this.material.render(commandEncoder, textureView);

        this.device.queue.submit([commandEncoder.finish()]);
    }

    loop() {
        let lastFrameTime = performance.now();
        let counter = 0;

        const frameLoop = () => {
            const currentFrameTime = performance.now();
            const deltaTime = currentFrameTime - lastFrameTime;
            const fps = 1000 / deltaTime;

            if ((counter += deltaTime) >= 5000) {
                console.log(`Delta time: ${deltaTime.toFixed(2)} ms, FPS: ${fps.toFixed(2)}`);
                counter = 0;
            }

            lastFrameTime = currentFrameTime;

            this.render();
            requestAnimationFrame(frameLoop);
        };

        frameLoop();
    }
}

const app = new Main();
app.initialize();