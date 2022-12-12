@enum Shape rock=1 paper=2 scissors=3
@enum Outcome lose=0 draw=3 won=6

decode_shape = Dict{Char, Shape}(
    'A' => rock,
    'B' => paper,
    'C' => scissors,
    'X' => rock,
    'Y' => paper,
    'Z' => scissors,
)

decode_outcome = Dict{Char, Outcome}(
    'X' => lose,
    'Y' => draw,
    'Z' => won,
)

# opponent, me
outcome = Dict{Tuple{Shape, Shape}, Outcome}(
    (rock, scissors) => lose,
    (scissors, paper) => lose,
    (paper, rock) => lose,
    (rock, rock) => draw,
    (scissors, scissors) => draw,
    (paper, paper) => draw,
    (scissors, rock) => won,
    (paper, scissors) => won,
    (rock, paper) => won,
)

# opponent, me
choice = Dict{Tuple{Shape, Outcome}, Shape}(
    (rock, lose) => scissors,
    (scissors, lose) => paper,
    (paper, lose) => rock,
    (rock, draw) => rock,
    (scissors, draw) => scissors,
    (paper, draw) => paper,
    (scissors, won) => rock,
    (paper, won) => scissors,
    (rock, won) => paper,
)

function part1(infile)
    strategy = readlines(infile)

    function score_for_line(line)
        opponent = decode_shape[line[1]]
        me = decode_shape[line[3]]
        oc = outcome[(opponent, me)]

        Int(me) + Int(oc)
    end

    sum(map(score_for_line, strategy))
end

function part2(infile)
    strategy = readlines(infile)

    function score_for_line(line)
        opponent = decode_shape[line[1]]
        oc = decode_outcome[line[3]]
        me = choice[(opponent, oc)]

        Int(me) + Int(oc)
    end

    sum(map(score_for_line, strategy))
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
