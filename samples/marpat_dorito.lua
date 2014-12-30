local am = amulet

local vshader = [[
    attribute float x;
    attribute float y;
    uniform mat4 MVP;
    void main() {
        gl_Position = MVP * vec4(x, y, 0, 1);
    }
]]

local fshader = [[
    precision mediump float;
    uniform sampler2D tex1;
    void main() {
        float scale = 0.3;
        vec2 uv = vec2(gl_FragCoord.x / 640.0, gl_FragCoord.y / 480.0) / scale;
        gl_FragColor = texture2D(tex1, uv);
    }
]]

local win = am.create_window({title = "Marpat Dorito", width = 640, height = 480})

local prog = am.program(vshader, fshader)

local vbuf = am.buffer(4 * 6)
local xview = vbuf:view("float", 0, 8)
local yview = vbuf:view("float", 4, 8)
xview[1] = -0.8
xview[2] = 0
xview[3] = 0.8
yview[1] = -0.7
yview[2] = 0.7
yview[3] = -0.7

local n = 16
local tbuf = am.buffer(n^2)
local tview = tbuf:view("ubyte", 0, 1)
for i = 1, n^2 do
    tview[i] = math.random() * 255
end
local texture = am.create_texture2d{
    width = n,
    height = n,
    swrap = "repeat",
    twrap = "repeat",
    format = "luminance",
    buffer = tbuf
}

local MVP = math.mat4(1)

local node = am.draw_arrays()
    :bind_array("x", xview)
    :bind_array("y", yview)
    :bind_sampler2d("tex1", texture)
    :bind_mat4("MVP", MVP)
    :program(prog)

--[[
node:action(function()
    for i = 1, n^2 do
        tview[i] = math.random() * 255
    end
    return 0
end)
]]

win.root = node