function parse_line(line)
    line = parse.(Int64, split(line, r",|-"))
    (line[1]:line[2], line[3]:line[4])
end

⊆(a, b) = a.start ≥ b.start && a.stop ≤ b.stop
subsets((a, b),) = a ⊆ b || b ⊆ a
overlaps((a, b),) = a.start ≤ b.stop && b.start ≤ a.stop

columns(M) = (view(M, :, i) for i in 1:size(M, 2))

function part1(infile)
    sum(map(subsets, parse_line.(readlines(infile))))
end

function part2(infile)
    sum(map(overlaps, parse_line.(readlines(infile))))
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
