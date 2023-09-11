const std = @import("std");
const at = @import("ansi-term");

const separator = "";

pub fn Powerline(comptime Writer: type) type {
    return struct {
        current_len: usize,
        last_style: ?at.Style,
        writer: Writer,
        max_len: usize,
        background: at.Color,

        const Self = @This();

        pub fn init(writer: Writer, max_len: usize, background: at.Color) Self {
            return .{
                .current_len = 0,
                .last_style = null,
                .writer = writer,
                .max_len = max_len,
                .background = background,
            };
        }

        pub fn draw(self: *Self, segment: Segment) !void {
            // +2 for worst-case separator width
            self.current_len += segment.text.len + 2;

            if (self.current_len > self.max_len)
                return;

            // last style != null -> not first segment
            if (self.last_style) |ls| {
                try self.setStyle(.{
                    .foreground = ls.background,
                    .background = self.background,
                });
                try self.writeSeparator();

                try self.setStyle(.{
                    .foreground = self.background,
                    .background = segment.style.background,
                });
                try self.writeSeparator();

                try self.setStyle(segment.style);
            } else {
                try self.setStyle(segment.style);
                try self.writer.writeAll(" ");
            }

            try self.writer.writeAll(segment.text);
        }

        pub fn finish(self: *Self) !void {
            try self.setStyle(.{
                .foreground = (self.last_style orelse at.Style{}).background,
            });

            try self.writeSeparator();
        }

        fn setStyle(self: *Self, style: at.Style) !void {
            try at.updateStyle(self.writer, style, self.last_style);
            self.last_style = style;
        }

        fn writeSeparator(self: *Self) !void {
            try self.writer.writeAll(separator);
        }
    };
}

const Segment = struct {
    style: at.Style,
    text: []const u8,
};
