struct Expr
    name::String
    lhs::String
    op::String
    rhs::String
end

function read_file(infile)
    result = Dict{String, Union{Int, Expr, Nothing}}()
    for line ∈ readlines(infile)
        (name, rest) = split(line, ": ")
        result[name] = isdigit(rest[1]) ? parse(Int, rest) : Expr(name, split(rest)...)
    end
    result
end

eval(env, name::String) = eval(env, env[name])
eval(env, value::Int) = value
function eval(env, expr::Expr)
    lhs = eval(env, expr.lhs)
    rhs = eval(env, expr.rhs)
    if expr.op == "+"
        result = lhs + rhs
    elseif expr.op == "-"
        result = lhs - rhs
    elseif expr.op == "*"
        result = lhs * rhs
    elseif expr.op == "/"
        result = lhs ÷ rhs
    else
        @assert false
    end
    env[expr.name] = result
    return result
end

simplify(env, ::Nothing) = nothing
simplify(env, name::String) = simplify(env, env[name])
simplify(env, value::Int) = value
function simplify(env, expr::Expr)
    lhs = simplify(env, expr.lhs)
    rhs = simplify(env, expr.rhs)
    if isnothing(lhs) || isnothing(rhs) || expr.name == "humn"
        return nothing
    end
    if expr.op == "+"
        result = lhs + rhs
    elseif expr.op == "-"
        result = lhs - rhs
    elseif expr.op == "*"
        result = lhs * rhs
    elseif expr.op == "/"
        result = lhs ÷ rhs
    else
        @assert false
    end
    env[expr.name] = result
    return result
end

function backprop(env, lhs::Int, op::String, rhs::Expr, expect::Int)
    if op == "="
        return backprop(env, env[rhs.lhs], rhs.op, env[rhs.rhs], lhs)
    elseif op == "+"
        return backprop(env, env[rhs.lhs], rhs.op, env[rhs.rhs], expect - lhs)
    elseif op == "-"
        return backprop(env, env[rhs.lhs], rhs.op, env[rhs.rhs], lhs - expect)
    elseif op == "*"
        return backprop(env, env[rhs.lhs], rhs.op, env[rhs.rhs], expect ÷ lhs)
    elseif op == "/"
        return backprop(env, env[rhs.lhs], rhs.op, env[rhs.rhs], lhs ÷ expect)
    else
        @assert false
    end
end

function backprop(env, lhs::Expr, op::String, rhs::Int, expect::Int)
    if op == "="
        return backprop(env, env[lhs.lhs], lhs.op, env[lhs.rhs], rhs)
    elseif op == "+"
        return backprop(env, env[lhs.lhs], lhs.op, env[lhs.rhs], expect - rhs)
    elseif op == "-"
        return backprop(env, env[lhs.lhs], lhs.op, env[lhs.rhs], expect + rhs)
    elseif op == "*"
        return backprop(env, env[lhs.lhs], lhs.op, env[lhs.rhs], expect ÷ rhs)
    elseif op == "/"
        return backprop(env, env[lhs.lhs], lhs.op, env[lhs.rhs], expect * rhs)
    else
        @assert false
    end
end

function backprop(env, lhs::Int, op::String, rhs::Nothing, expect::Int)
    if op == "="
        return lhs
    elseif op == "+"
        return expect - lhs
    elseif op == "-"
        return lhs - expect
    elseif op == "*"
        return expect / lhs
    elseif op == "/"
        return lhs / expect
    else
        @assert false
    end
end

function backprop(env, lhs::Nothing, op::String, rhs::Int, expect::Int)
    if op == "="
        return rhs
    elseif op == "+"
        return expect - rhs
    elseif op == "-"
        return expect + rhs
    elseif op == "*"
        return expect / rhs
    elseif op == "/"
        return expect * rhs
    else
        @assert false
    end
end

function part1(infile)
    env = read_file(infile)
    eval(env, "root")
end
function part2(infile)
    env = read_file(infile)
    env["humn"] = nothing
    simplify(env, "root")
    backprop(env, env[env["root"].lhs], "=", env[env["root"].rhs], -1)
end

print("test part 1: ", part1("testinput"), "\n")
print("test part 2: ", part2("testinput"), "\n")

print("actual part 1: ", part1("input"), "\n")
print("actual part 2: ", part2("input"), "\n")
