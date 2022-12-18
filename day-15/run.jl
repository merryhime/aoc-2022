import Scanf

parse_line(line) = (@Scanf.scanf line "Sensor at x=%i, y=%i: closest beacon is at x=%i, y=%i" Int Int Int Int)[2:end]
manhattan(a, b) = sum(abs.(a .- b))

⊆(a, b) = a.start ≥ b.start && a.stop ≤ b.stop
overlaps(a, b) = a.start ≤ b.stop + 1 && b.start ≤ a.stop + 1
merge(a, b) = min(a.start, b.start):max(a.stop, b.stop)
cover(a) = a.stop - a.start + 1

function push_interval!(list, new)
    if isempty(list)
        push!(list, new)
        return
    end
    o = filter(x -> overlaps(x, new), list)
    filter!(x -> !overlaps(x, new), list)
    push!(o, new)
    push!(list, reduce(merge, o))
end

function beacons_on_row(lines, row)
    res = Set{Int}()
    for (sx, sy, bx, by) ∈ lines
        by != row && continue
        push!(res, bx)
    end
    length(res)
end

function row_coverage(lines, row)
    res = Vector{UnitRange{Int}}()
    for (sx, sy, bx, by) ∈ lines
        d = manhattan((sx, sy), (bx, by))
        delta = d - abs(row - sy)
        delta ≤ 0 && continue
        push_interval!(res, sx-delta:sx+delta)
    end
    res
end

function part1(infile, row)
    lines = parse_line.(readlines(infile))
    coverage = row_coverage(lines, row)
    sum(cover, coverage) - beacons_on_row(lines, row)
end

function search_empty(infile, search_size)
    lines = parse_line.(readlines(infile))
    for row ∈ 1:search_size
        coverage = row_coverage(lines, row)
        filter!(x -> overlaps(x, 0:search_size), coverage)
        if length(coverage) != 1
            display(coverage)
            @assert length(coverage) == 2
            @assert coverage[1].stop + 2 == coverage[2].start
            x = coverage[1].stop + 1
            y = row
            return x * 4000000 + y
        end
    end
end

print("test part 1: ", part1("testinput", 10), "\n")
print("test part 2: ", search_empty("testinput", 20), "\n")

print("actual part 1: ", part1("input", 2000000), "\n")
print("actual part 2: ", search_empty("input", 4000000), "\n")
