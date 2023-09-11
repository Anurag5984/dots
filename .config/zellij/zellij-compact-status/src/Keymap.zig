const std = @import("std");
const zz = @import("zellzig");
const at = @import("ansi-term");

const sets = @import("settings.zig");

const Key = zz.types.Key;
const Keybind = zz.types.Keybind;
const Action = zz.types.Action;

normal: Normal = .{},
pane: Pane = .{},
tab: Tab = .{},
resize: Resize = .{},
move: Move = .{},
search: Search = .{},
session: Session = .{},

const Self = @This();

pub fn populate(self: *Self, bind_sets: []zz.types.KeybindSet) void {
    for (bind_sets) |set| {
        switch (set.@"0") {
            .Normal => self.normal.populate(set.@"1"),
            .Pane => self.pane.populate(set.@"1"),
            .Tab => self.tab.populate(set.@"1"),
            .Resize => self.resize.populate(set.@"1"),
            .Move => self.move.populate(set.@"1"),
            .Search, .Scroll => self.search.populate(set.@"1"),
            else => {},
        }
    }
}

fn findKey(kbs: []Keybind, action: Action) ?Key {
    for (kbs) |kb| {
        for (kb.@"1") |ac| {
            if (std.meta.eql(ac, action)) {
                return kb.@"0";
            }
        }
    }

    return null;
}

fn drawKey(
    pl: anytype,
    pal: zz.types.Palette,
    comptime fmt: []const u8,
    key: ?Key,
) !void {
    if (key) |k| {
        var buf: [512]u8 = undefined;
        const fmt_k = FmtKey{ .k = k };
        try pl.draw(.{
            .text = try std.fmt.bufPrint(&buf, fmt, .{fmt_k}),
            .style = fmt_k.style(pal),
        });
    }
}

/// gets the inner key, for example takes returns the key inside of .{ .Alt = ... }
fn innerCharOrArrow(key: Key) ?zz.types.CharOrArrow {
    return switch (key) {
        .Alt => |k| k,
        .Ctrl => |c| .{ .Char = c },
        .Char => |c| .{ .Char = c },
        .Left => .{ .Direction = .Left },
        .Right => .{ .Direction = .Right },
        .Up => .{ .Direction = .Up },
        .Down => .{ .Direction = .Down },
        else => null,
    };
}

fn arrowKeys(left_: ?Key, right_: ?Key, up_: ?Key, down_: ?Key) bool {
    var left = if (left_) |k| innerCharOrArrow(k) else null;
    var right = if (right_) |k| innerCharOrArrow(k) else null;
    var up = if (up_) |k| innerCharOrArrow(k) else null;
    var down = if (down_) |k| innerCharOrArrow(k) else null;

    if (!std.meta.eql(
        left,
        .{ .Direction = .Left },
    ) and !std.meta.eql(
        left,
        .{ .Char = .{ .c = 'h' } },
    )) return false;

    if (!std.meta.eql(
        right,
        .{ .Direction = .Right },
    ) and !std.meta.eql(
        right,
        .{ .Char = .{ .c = 'l' } },
    )) return false;

    if (!std.meta.eql(
        up,
        .{ .Direction = .Up },
    ) and !std.meta.eql(
        up,
        .{ .Char = .{ .c = 'k' } },
    )) return false;

    if (!std.meta.eql(
        down,
        .{ .Direction = .Down },
    ) and !std.meta.eql(
        down,
        .{ .Char = .{ .c = 'j' } },
    )) return false;

    return true;
}

fn altArrowKeys(left: ?Key, right: ?Key, up: ?Key, down: ?Key) bool {
    if (!std.meta.eql(
        left,
        .{ .Alt = .{ .Direction = .Left } },
    ) and !std.meta.eql(
        left,
        .{ .Alt = .{ .Char = .{ .c = 'h' } } },
    )) return false;

    if (!std.meta.eql(
        right,
        .{ .Alt = .{ .Direction = .Right } },
    ) and !std.meta.eql(
        right,
        .{ .Alt = .{ .Char = .{ .c = 'l' } } },
    )) return false;

    if (!std.meta.eql(
        up,
        .{ .Alt = .{ .Direction = .Up } },
    ) and !std.meta.eql(
        up,
        .{ .Alt = .{ .Char = .{ .c = 'k' } } },
    )) return false;

    if (!std.meta.eql(
        down,
        .{ .Alt = .{ .Direction = .Down } },
    ) and !std.meta.eql(
        down,
        .{ .Alt = .{ .Char = .{ .c = 'j' } } },
    )) return false;

    return true;
}

const FmtKey = struct {
    k: Key,

    pub fn format(
        self: FmtKey,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        w: anytype,
    ) !void {
        switch (self.k) {
            .PageUp, .PageDown => try w.writeAll(" "),
            .Left => try w.writeAll(directionChar(.Left)),
            .Right => try w.writeAll(directionChar(.Right)),
            .Up => try w.writeAll(directionChar(.Up)),
            .Down => try w.writeAll(directionChar(.Down)),
            .Home => try w.writeAll("ﮟ"),
            .End => try w.writeAll("ײַ"),
            .Backspace => try w.writeAll(""),
            .Delete => try w.writeAll("del"),
            .Insert => try w.writeAll("ins"),
            .F => |n| try w.print("F{d}", .{n}),
            .Char => |c| try w.writeByte(c.c),
            .Alt => |c| switch (c) {
                .Char => |char| try w.print("<M-{c}>", .{char.c}),
                .Direction => |dir| try w.print("<M-{s}>", .{directionChar(dir)}),
            },
            .Ctrl => |c| try w.print("<C-{c}>", .{c.c}),
            .BackTab => try w.writeAll("backtab"),
            .Null => try w.writeAll("null"),
            .Esc => try w.writeAll("esc"),
        }
    }

    pub fn style(self: FmtKey, pal: zz.types.Palette) at.Style {
        return switch (self.k) {
            .Alt => sets.altStyle(pal),
            .Ctrl => sets.ctrlStyle(pal),
            else => sets.singleStyle(pal),
        };
    }

    fn directionChar(dir: zz.types.Direction) []const u8 {
        return switch (dir) {
            .Left => "",
            .Right => "",
            .Up => "",
            .Down => "",
        };
    }
};

pub const Normal = struct {
    lock_mode: ?Key = null,
    pane_mode: ?Key = null,
    tab_mode: ?Key = null,
    resize_mode: ?Key = null,
    move_mode: ?Key = null,
    search_mode: ?Key = null,
    session_mode: ?Key = null,
    quit: ?Key = null,
    focus_left: ?Key = null,
    focus_right: ?Key = null,
    focus_up: ?Key = null,
    focus_down: ?Key = null,
    new: ?Key = null,
    increase_size: ?Key = null,
    decrease_size: ?Key = null,

    pub fn populate(self: *Normal, kbs: []Keybind) void {
        self.lock_mode = findKey(kbs, .{ .SwitchToMode = .Locked });
        self.pane_mode = findKey(kbs, .{ .SwitchToMode = .Pane });
        self.tab_mode = findKey(kbs, .{ .SwitchToMode = .Tab });
        self.resize_mode = findKey(kbs, .{ .SwitchToMode = .Resize });
        self.move_mode = findKey(kbs, .{ .SwitchToMode = .Move });
        self.search_mode = findKey(kbs, .{ .SwitchToMode = .Search }) orelse
            findKey(kbs, .{ .SwitchToMode = .Scroll });
        self.session_mode = findKey(kbs, .{ .SwitchToMode = .Session });
        self.quit = findKey(kbs, .Quit);
        self.focus_left = findKey(kbs, .{ .MoveFocusOrTab = .Left });
        self.focus_right = findKey(kbs, .{ .MoveFocusOrTab = .Right });
        self.focus_up = findKey(kbs, .{ .MoveFocus = .Up });
        self.focus_down = findKey(kbs, .{ .MoveFocus = .Down });
        // matching direction and pane name here is incredibly stupid,
        // but let's hope this won't explode until this is moved into zellij
        self.new = findKey(kbs, .{ .NewPane = .{ null, null } });
        self.increase_size = findKey(kbs, .{ .Resize = .{ .Increase, null } });
        self.decrease_size = findKey(kbs, .{ .Resize = .{ .Decrease, null } });
    }

    pub fn draw(self: *Normal, pl: anytype, pal: zz.types.Palette) !void {
        try drawKey(pl, pal, "{} |  ", self.lock_mode);
        try drawKey(pl, pal, "{} |  ", self.pane_mode);
        try drawKey(pl, pal, "{} | ﴵ ", self.tab_mode);
        try drawKey(pl, pal, "{} | ﭕ ", self.resize_mode);
        try drawKey(pl, pal, "{} |  ", self.move_mode);
        try drawKey(pl, pal, "{} |  ", self.search_mode);
        try drawKey(pl, pal, "{} |  ", self.session_mode);
        try drawKey(pl, pal, "{} |  ", self.quit);

        if (altArrowKeys(
            self.focus_left,
            self.focus_right,
            self.focus_up,
            self.focus_down,
        )) {
            try pl.draw(.{ .text = "<M->", .style = sets.altStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} |  ", self.focus_left);
            try drawKey(pl, pal, "{} |  ", self.focus_right);
            try drawKey(pl, pal, "{} |  ", self.focus_up);
            try drawKey(pl, pal, "{} |  ", self.focus_down);
        }

        try drawKey(pl, pal, "{} |  ", self.new);

        if (std.meta.eql(self.increase_size, .{ .Alt = .{ .Char = .{ .c = '+' } } }) and
            std.meta.eql(self.decrease_size, .{ .Alt = .{ .Char = .{ .c = '-' } } }))
        {
            try pl.draw(.{ .text = "<M-+/-> | ﭔ ", .style = sets.altStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} | +ﭔ ", self.increase_size);
            try drawKey(pl, pal, "{} | -ﭔ ", self.decrease_size);
        }
    }
};

pub const Pane = struct {
    focus_left: ?Key = null,
    focus_right: ?Key = null,
    focus_up: ?Key = null,
    focus_down: ?Key = null,
    next: ?Key = null,
    new: ?Key = null,
    split_down: ?Key = null,
    split_right: ?Key = null,
    close: ?Key = null,
    fullscreen: ?Key = null,
    frame: ?Key = null,
    rename: ?Key = null,
    floating: ?Key = null,
    embed: ?Key = null,

    pub fn populate(self: *Pane, kbs: []Keybind) void {
        self.focus_left = findKey(kbs, .{ .MoveFocus = .Left });
        self.focus_right = findKey(kbs, .{ .MoveFocus = .Right });
        self.focus_up = findKey(kbs, .{ .MoveFocus = .Up });
        self.focus_down = findKey(kbs, .{ .MoveFocus = .Down });
        self.next = findKey(kbs, .SwitchFocus);
        self.new = findKey(kbs, .{ .NewPane = .{ null, null } });
        self.split_down = findKey(kbs, .{ .NewPane = .{ .Down, null } });
        self.split_right = findKey(kbs, .{ .NewPane = .{ .Right, null } });
        self.close = findKey(kbs, .CloseFocus);
        self.fullscreen = findKey(kbs, .ToggleFocusFullscreen);
        self.frame = findKey(kbs, .TogglePaneFrames);
        self.rename = findKey(kbs, .{ .SwitchToMode = .RenamePane });
        self.floating = findKey(kbs, .ToggleFloatingPanes);
        self.embed = findKey(kbs, .TogglePaneEmbedOrFloating);
    }

    pub fn draw(self: *Pane, pl: anytype, pal: zz.types.Palette) !void {
        if (arrowKeys(self.focus_left, self.focus_right, self.focus_up, self.focus_down)) {
            try pl.draw(.{ .text = " ", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} |  ", self.focus_left);
            try drawKey(pl, pal, "{} |  ", self.focus_right);
            try drawKey(pl, pal, "{} |  ", self.focus_up);
            try drawKey(pl, pal, "{} |  ", self.focus_down);
        }

        try drawKey(pl, pal, "{} | 怜", self.next);
        try drawKey(pl, pal, "{} |  ", self.new);
        try drawKey(pl, pal, "{} |   ", self.split_down);
        try drawKey(pl, pal, "{} |   ", self.split_right);
        try drawKey(pl, pal, "{} |  ", self.close);
        try drawKey(pl, pal, "{} |  ", self.fullscreen);
        try drawKey(pl, pal, "{} |  ", self.frame);
        try drawKey(pl, pal, "{} | 凜", self.rename);
        try drawKey(pl, pal, "{} |  ", self.floating);
        try drawKey(pl, pal, "{} |  ", self.embed);
    }
};

pub const Tab = struct {
    focus_left: ?Key = null,
    focus_right: ?Key = null,
    toggle_tab: ?Key = null,
    new: ?Key = null,
    close: ?Key = null,
    rename: ?Key = null,
    sync: ?Key = null,

    pub fn populate(self: *Tab, kbs: []Keybind) void {
        self.focus_left = findKey(kbs, .GoToPreviousTab);
        self.focus_right = findKey(kbs, .GoToNextTab);
        self.toggle_tab = findKey(kbs, .ToggleTab);
        self.new = findKey(kbs, .{ .NewTab = .{ null, &.{}, null } });
        self.close = findKey(kbs, .Quit);
        self.rename = findKey(kbs, .{ .SwitchToMode = .RenameTab });
        self.sync = findKey(kbs, .ToggleActiveSyncTab);
    }

    pub fn draw(self: *Tab, pl: anytype, pal: zz.types.Palette) !void {
        if (arrowKeys(self.focus_left, self.focus_right, .Up, .Down)) {
            try pl.draw(.{ .text = " ", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} |  ", self.focus_left);
            try drawKey(pl, pal, "{} |  ", self.focus_right);
        }

        if (std.meta.eql(self.toggle_tab, .{ .Char = .{ .c = '\t' } })) {
            try pl.draw(.{ .text = "⇋ ", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} | ⇋ ", self.toggle_tab);
        }

        try drawKey(pl, pal, "{} |  ", self.new);
        try drawKey(pl, pal, "{} |  ", self.close);
        try drawKey(pl, pal, "{} | 凜", self.rename);
    }
};

pub const Resize = struct {
    resize_left: ?Key = null,
    resize_right: ?Key = null,
    resize_up: ?Key = null,
    resize_down: ?Key = null,
    increase: ?Key = null,
    decrease: ?Key = null,

    pub fn populate(self: *Resize, kbs: []Keybind) void {
        self.resize_left = findKey(kbs, .{ .Resize = .{ .Increase, .Left } });
        self.resize_right = findKey(kbs, .{ .Resize = .{ .Increase, .Right } });
        self.resize_up = findKey(kbs, .{ .Resize = .{ .Increase, .Up } });
        self.resize_down = findKey(kbs, .{ .Resize = .{ .Increase, .Down } });
        self.increase = findKey(kbs, .{ .Resize = .{ .Increase, null } });
        self.decrease = findKey(kbs, .{ .Resize = .{ .Decrease, null } });
    }

    pub fn draw(self: *Resize, pl: anytype, pal: zz.types.Palette) !void {
        if (arrowKeys(
            self.resize_left,
            self.resize_right,
            self.resize_up,
            self.resize_down,
        )) {
            try pl.draw(.{ .text = " ", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} |  ", self.resize_left);
            try drawKey(pl, pal, "{} |  ", self.resize_right);
            try drawKey(pl, pal, "{} |  ", self.resize_up);
            try drawKey(pl, pal, "{} |  ", self.resize_down);
        }

        if (std.meta.eql(self.increase, .{ .Char = .{ .c = '+' } }) and
            std.meta.eql(self.decrease, .{ .Char = .{ .c = '-' } }))
        {
            try pl.draw(.{ .text = "+-", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} | + ", self.increase);
            try drawKey(pl, pal, "{} | - ", self.decrease);
        }
    }
};

pub const Move = struct {
    move_left: ?Key = null,
    move_right: ?Key = null,
    move_up: ?Key = null,
    move_down: ?Key = null,
    move: ?Key = null,

    pub fn populate(self: *Move, kbs: []Keybind) void {
        self.move_left = findKey(kbs, .{ .MovePane = .Left });
        self.move_right = findKey(kbs, .{ .MovePane = .Right });
        self.move_up = findKey(kbs, .{ .MovePane = .Up });
        self.move_down = findKey(kbs, .{ .MovePane = .Down });
        self.move = findKey(kbs, .{ .MovePane = null });
    }

    pub fn draw(self: *Move, pl: anytype, pal: zz.types.Palette) !void {
        if (arrowKeys(
            self.move_left,
            self.move_right,
            self.move_up,
            self.move_down,
        )) {
            try pl.draw(.{ .text = " ", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} |  ", self.move_left);
            try drawKey(pl, pal, "{} |  ", self.move_right);
            try drawKey(pl, pal, "{} |  ", self.move_up);
            try drawKey(pl, pal, "{} |  ", self.move_down);
        }

        if (std.meta.eql(self.move, .{ .Char = .{ .c = '\t' } })) {
            try pl.draw(.{ .text = "⇋ ", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} | ⇋ ", self.move);
        }
    }
};

pub const Search = struct {
    scroll_up: ?Key = null,
    scroll_down: ?Key = null,
    page_up: ?Key = null,
    page_down: ?Key = null,
    half_page_up: ?Key = null,
    half_page_down: ?Key = null,
    edit: ?Key = null,
    search: ?Key = null,

    pub fn populate(self: *Search, kbs: []Keybind) void {
        self.scroll_up = findKey(kbs, .ScrollUp);
        self.scroll_down = findKey(kbs, .ScrollDown);
        self.page_up = findKey(kbs, .PageScrollUp);
        self.page_down = findKey(kbs, .PageScrollDown);
        self.half_page_up = findKey(kbs, .HalfPageScrollUp);
        self.half_page_down = findKey(kbs, .HalfPageScrollDown);
        self.edit = findKey(kbs, .EditScrollback);
        self.search = findKey(kbs, .{ .SwitchToMode = .EnterSearch });
    }

    pub fn draw(self: *Search, pl: anytype, pal: zz.types.Palette) !void {
        if (arrowKeys(.Left, .Right, self.scroll_up, self.scroll_down)) {
            try pl.draw(.{ .text = "", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} |  ", self.scroll_up);
            try drawKey(pl, pal, "{} |  ", self.scroll_down);
        }

        if (std.meta.eql(self.page_up, .PageUp) and
            std.meta.eql(self.page_down, .PageDown))
        {
            try pl.draw(.{ .text = "  ", .style = sets.singleStyle(pal) });
        } else {
            try drawKey(pl, pal, "{} |   ", self.page_up);
            try drawKey(pl, pal, "{} |   ", self.page_up);
        }

        try drawKey(pl, pal, "{} | ﯕ  ", self.half_page_up);
        try drawKey(pl, pal, "{} | ﯕ  ", self.half_page_down);
        try drawKey(pl, pal, "{} |  ", self.edit);
        try drawKey(pl, pal, "{} |  ", self.search);
    }
};

pub const Session = struct {
    detach: ?Key = null,

    pub fn populate(self: *Search, kbs: []Keybind) void {
        self.detach = findKey(kbs, .Detach);
    }

    pub fn draw(self: *Session, pl: anytype, pal: zz.types.Palette) !void {
        try drawKey(pl, pal, "{} |  ", self.detach);
    }
};
