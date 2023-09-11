const std = @import("std");
const zz = @import("zellzig");
const at = @import("ansi-term");
const Keymap = @import("Keymap.zig");
const powerline = @import("powerline.zig");
const sets = @import("settings.zig");
const util = @import("util.zig");

const sty = util.sty;
const col = util.col;

comptime {
    zz.createPlugin(@This());
}

// this is fine, as we should always get a mode event before rendering
var mode: zz.types.InputMode = undefined;
var pal: zz.types.Palette = undefined;
var keymap: Keymap = .{};

pub const zellij_version = "0.34.5";

pub fn init() void {
    zz.api.setSelectable(false);
    zz.api.subscribe(&[_]zz.types.EventType{.ModeUpdate}) catch
        @panic("unable to subscribe to events");
}

var event_heap: [1024 * 128]u8 = undefined;
var event_fba = std.heap.FixedBufferAllocator.init(&event_heap);
pub fn update() bool {
    defer event_fba.end_index = 0;
    var err_ctx: ?zz.DeserErrorCtx = null;
    var ev = zz.getEvent(event_fba.allocator(), &err_ctx) catch |e| {
        std.log.err("Failed to deserialize event: {}", .{e});
        if (err_ctx) |ctx| {
            defer ctx.deinit();
            std.log.err(
                \\At char {d}:
                \\{s}
                \\                ^
            ,
                .{ctx.pos, ctx.sample},
            );
        }
        return false;
    };

    switch (ev.data) {
        .ModeUpdate => |info| {
            mode = info.mode;
            pal = info.style.colors;
            keymap.populate(info.keybinds);
            return true;
        },
        else => {},
    }
    return false;
}

fn tryRender(cols: usize) !void {
    const stdout = std.io.getStdOut().writer();
    var writer = std.io.bufferedWriter(stdout);
    var pl = powerline.Powerline(@TypeOf(writer.writer())).init(
        writer.writer(),
        cols,
        col(pal.bg),
    );

    switch (mode) {
        .Locked => {
            try pl.draw(.{
                .text = "<C-g>  ",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.red,
                    .bg = pal.black,
                }),
            });
        },

        .Normal => {
            try pl.draw(.{
                .text = "Normal",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.yellow,
                }),
            });

            try keymap.normal.draw(&pl, pal);
        },

        .Pane => {
            try pl.draw(.{
                .text = "Pane",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.blue,
                }),
            });

            try keymap.pane.draw(&pl, pal);
        },

        .Tab => {
            try pl.draw(.{
                .text = "Tab",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.cyan,
                }),
            });

            try keymap.tab.draw(&pl, pal);
        },

        .Resize => {
            try pl.draw(.{
                .text = "Resize",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.red,
                }),
            });

            try keymap.resize.draw(&pl, pal);
        },

        .Move => {
            try pl.draw(.{
                .text = "Move",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.cyan,
                }),
            });

            try keymap.move.draw(&pl, pal);
        },

        .Scroll, .Search => {
            try pl.draw(.{
                .text = "Search",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.green,
                }),
            });

            try keymap.search.draw(&pl, pal);
        },

        .Session => {
            try pl.draw(.{
                .text = "Session",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.blue,
                    .bg = pal.red,
                }),
            });

            try keymap.session.draw(&pl, pal);
        },

        .RenameTab => {
            try pl.draw(.{
                .text = "Rename Tab",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.blue,
                }),
            });
        },

        .RenamePane => {
            try pl.draw(.{
                .text = "Rename Pane",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.blue,
                }),
            });
        },

        .Prompt => {
            try pl.draw(.{
                .text = "Prompt",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.white,
                    .bg = pal.purple,
                }),
            });
        },

        .Tmux => {
            try pl.draw(.{
                .text = "TMUX",
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.white,
                    .bg = pal.brown,
                }),
            });
        },
        else => {
            try pl.draw(.{
                .text = @tagName(mode),
                .style = sty(.{
                    .font = .{ .bold = true },
                    .fg = pal.black,
                    .bg = pal.blue,
                }),
            });
        },
    }

    try pl.finish();
    try writer.flush();
}

pub fn render(rows: i32, cols: i32) void {
    _ = rows;
    tryRender(@intCast(usize, cols)) catch |e| {
        std.log.err("Failed to render: {}", .{e});
    };
}
