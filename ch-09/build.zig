const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "hello",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.graph.host // current machine
        })
    });
    b.installArtifact(exe);
    
    const test_exe = b.addTest(.{
        .name = "unit tests",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.graph.host
        })
    });
    b.installArtifact(test_exe);
    
    // Add build run step
    const run_arti = b.addRunArtifact(exe);
    const run_step = b.step("run", "run hello exe");
    run_step.dependOn(&run_arti.step);
    
    // Add unit test run step
    const run_test_arti = b.addRunArtifact(test_exe);
    const run_test_step = b.step("run-test", "run unit tests");
    run_test_step.dependOn(&run_test_arti.step);
}