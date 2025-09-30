const std = @import("std");
const scanner = @import("scanner.zig");
const token = @import("token.zig");
const Runner = @This();

var hadError: bool = false;

pub fn start() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args = std.process.args();
    defer args.deinit();

    while (args.next()) |arg| {
        std.debug.print("arg: .{s}\n", .{arg});
    }

    //
    if (args.inner.count > 2) {
        std.debug.print("Usage: zlox [script]", .{});
    } else if (args.inner.count == 2) {
        // file
    } else {
        // repl
        try runPrompt(allocator);
    }
}

fn runFile(allocator: std.mem.Allocator, path: []u8) !void {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);

    const reader = file.reader(buffer).interface;
    reader.takeByte();

    run(allocator, reader);
}

fn runPrompt(allocator: std.mem.Allocator) !void {
    const input_stream = std.fs.File.stdin();
    const buffer = try allocator.alloc(u8, 4096);
    defer allocator.free(buffer);
    var reader = input_stream.reader(buffer).interface;

    while (true) {
        std.debug.print("> ", .{});

        // TODO: catch error.EndOfStream error after takeDelimiterInclusive
        const line = try reader.takeDelimiterInclusive('\n');
        var line_reader = std.Io.Reader.fixed(line);

        try run(allocator, &line_reader);
    }
}

fn run(allocator: std.mem.Allocator, source: *std.Io.Reader) !void {
    var tokens = try scanner.scanTokens(allocator, source);
    defer tokens.deinit(allocator);

    for (tokens.items) |t| {
        defer {
            allocator.free(t.lexeme);
            if (t.literal == .identifier_string) {
                allocator.free(t.literal.identifier_string);
            }
        }

        const m = try t.toString(allocator);
        defer allocator.free(m);
        std.debug.print("{s}\n", .{m});
    }
}

fn compilerError(line_num: u32, message: []u8) void {
    const where = "";
    report(line_num, where[0..where.len], message);
}

fn report(line_num: u32, where: []u8, message: []u8) void {
    std.debug.print("[line {d} Error{s}: {s}\n", .{ line_num, where, message });
}
