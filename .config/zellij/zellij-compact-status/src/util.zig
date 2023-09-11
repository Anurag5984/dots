const zz = @import("zellzig");
const at = @import("ansi-term");

pub fn sty(palette_style: struct {
    font: at.FontStyle = .{},
    bg: zz.types.PaletteColor,
    fg: zz.types.PaletteColor,
}) at.Style {
    return .{
        .font_style = palette_style.font,
        .background = col(palette_style.bg),
        .foreground = col(palette_style.fg),
    };
}

pub fn col(color: zz.types.PaletteColor) at.Color {
    return switch (color) {
        .Rgb => |rgb| .{ .RGB = .{ .r = rgb[0], .g = rgb[1], .b = rgb[2] } },
        .EightBit => |c| .{ .Fixed = c },
    };
}
