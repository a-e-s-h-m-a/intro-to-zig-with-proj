// const std = @import("std");
// const LazyPath = std.Build.LazyPath;

// pub fn build(b: *std.Build) void {
//     const exe = b.addExecutable(.{ .name = "image_filter", .root_module = b.createModule(.{ .root_source_file = b.path("src/image_filter.zig"), .target = b.graph.host, .link_libc = true })});
//     //Link to libspng library
//     exe.root_module.linkSystemLibrary("spng", .{});
//     exe.root_module.linkSystemLibrary("m", .{});
//     exe.root_module.addIncludePath(.{ .cwd_relative = "/opt/homebrew/include" });
//     exe.root_module.addLibraryPath(.{ .cwd_relative = "/opt/homebrew/lib" });

//     b.installArtifact(exe);
//     const run_cmd = b.addRunArtifact(exe);
//     run_cmd.step.dependOn(b.getInstallStep());
//     const run_step = b.step("run", "run the App");
//     run_step.dependOn(&run_cmd.step);
// }

const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "image_filter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/image_filter.zig"),
            .target = b.graph.host,
            .link_libc = true,
        }),
    });

    exe.root_module.linkSystemLibrary("spng", .{
        .use_pkg_config = .force,
    });

    exe.root_module.linkSystemLibrary("m", .{});

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}