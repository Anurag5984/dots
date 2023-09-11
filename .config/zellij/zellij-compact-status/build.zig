const std = @import("std");
const pkgs = @import("deps.zig").pkgs;

pub fn build(b: *std.build.Builder) !void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addSharedLibrary("zellij-compact-status", "src/main.zig", .{ .unversioned = {} });
    lib.setBuildMode(mode);

    lib.target.cpu_arch = .wasm32;
    lib.target.os_tag = .wasi;
    lib.rdynamic = true;
    lib.strip = mode != .Debug;

    pkgs.addAllTo(lib);

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    b.getInstallStep().dependOn(&(try InstallStep.init(b, lib)).step);
}

const InstallStep = struct {
    builder: *std.build.Builder,
    step: std.build.Step,
    lib: *std.build.LibExeObjStep,

    pub fn init(builder: *std.build.Builder, lib: *std.build.LibExeObjStep) !*InstallStep {
        const self = try builder.allocator.create(InstallStep);
        self.* = .{
            .builder = builder,
            .lib = lib,
            .step = std.build.Step.init(.custom, "install", builder.allocator, make),
        };
        self.step.dependOn(&lib.step);
        return self;
    }

    fn make(step: *std.build.Step) anyerror!void {
        const self = @fieldParentPtr(InstallStep, "step", step);

        const plugin_install_dir = std.build.InstallDir{
            .custom = "share/zellij/plugins",
        };
        const plugin_basename = "compact-status.wasm";

        const dest_path = self.builder.getInstallPath(
            plugin_install_dir,
            plugin_basename,
        );

        try self.builder.updateFile(
            self.lib.getOutputSource().getPath(self.builder),
            dest_path,
        );
        // FIXME: the uninstall step doesn't do anything, despite this
        self.builder.pushInstalledFile(plugin_install_dir, plugin_basename);
    }
};
