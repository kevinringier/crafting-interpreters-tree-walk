const std = @import("std");
const runner = @import("runner.zig");

pub fn main() !void {
    try runner.start();
}

fn runFile(allocator: std.mem.Allocator, path: []u8) !void {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);

    const reader = file.reader(buffer).interface;

    run(allocator, reader);
}

fn runPrompt(allocator: std.mem.Allocator) !void {
    const input_stream = std.fs.File.stdin();
    const buffer = try allocator.alloc(u8, 4096);
    var reader = input_stream.reader(buffer).interface;

    while (true) {
        std.debug.print("> ", .{});
        const line = try reader.takeDelimiterInclusive('\n');
        try run(allocator, line);
    }
}

fn run(_: std.mem.Allocator, source: []u8) !void {
    std.debug.print("{s}", .{source});
    const scanner = @import("scanner.zig");

    const tokens = try scanner.scanTokens();

    for (tokens) |_| {
        std.debug.print("test", .{});
    }
}

fn compilerError(line_num: u32, message: []u8) void {
    const where = "";
    report(line_num, where[0..where.len], message);
}

fn report(line_num: u32, where: []u8, message: []u8) void {
    std.debug.print("[line {d} Error{s}: {s}\n", .{ line_num, where, message });
}
