const zz = @import("zellzig");
const at = @import("ansi-term");
const sty = @import("util.zig").sty;

// There's really no good palette color to use for this in zellij. I'll add this
// as a custom plugin option once that's possible.
const alt_bg = zz.types.PaletteColor{ .Rgb = [_]u8{ 68, 71, 90 } };
pub fn ctrlStyle(pal: zz.types.Palette) at.Style {
    return sty(.{ .fg = pal.blue, .bg = alt_bg });
}

pub fn altStyle(pal: zz.types.Palette) at.Style {
    return sty(.{ .fg = pal.green, .bg = alt_bg });
}

pub fn singleStyle(pal: zz.types.Palette) at.Style {
    return sty(.{ .fg = pal.magenta, .bg = alt_bg });
}
