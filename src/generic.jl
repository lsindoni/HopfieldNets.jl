abstract type HopfieldNet end

function energy(net::HopfieldNet)
    # Comment: No bias included
    return -0.5 * (net.s' * net.W * net.s) #+ (net.W[:, 1]' * net.s)
end


function settle!(net::HopfieldNet,
                 iterations::Integer = 1_000,
                 trace::Bool = false)
    for i in 1:iterations
        update!(net)
        if trace
            @printf "%5.0d: %.4f\n" i energy(net)
        end
    end
    return
end

function associate!(net::HopfieldNet,
                               pattern::Vector{<:Real};
                               iterations::Integer = 1_000,
                               trace::Bool = false)
    copy!(net.s, pattern)
    settle!(net, iterations, trace)
    # TODO: Decide if this should really be a copy
    return copy(net.s)
end

# Hebbian learning steps w/ columns as patterns
function train!(net::HopfieldNet, patterns::Matrix{<:Real})
    n = size(patterns, 1)
    p = size(patterns, 2)
    for idx in 1:p
        δW = (patterns[:, idx] * patterns[:, idx]')
        # self-connections are switched off
        δW -= Diagonal(diag(δW))
        net.W += δW ./ n
    end
    return
end


function h(i::Integer, j::Integer, mu::Integer, W::Matrix{Float64}, patterns::Matrix{<:Real})
    idxs = setdiff(1:size(W, 1), [i, j])
    res = W[i, idxs]' * patterns[idxs, mu]
    return res
end


# Storkey learning steps w/ columns as patterns
function storkeytrain!(net::HopfieldNet, patterns::Matrix{<:Real})
    n = length(net.s)
    p = size(patterns, 2)
    for mu in 1:p
        δW = zeros(size(net.W))
        for i in 1:n
            for j in (i + 1):n
                s = patterns[i, mu] * patterns[j, mu]
                s -= patterns[i, mu] * h(j, i, mu, net.W, patterns)
                s -= h(i, j, mu, net.W, patterns) * patterns[j, mu]
                δW[i, j] += s
                δW[j, i] += s
            end
        end
        net.W += δW ./ n
    end
    return
end
