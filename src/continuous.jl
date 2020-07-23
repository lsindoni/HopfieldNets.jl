mutable struct ContinuousHopfieldNet <: HopfieldNet
    s::Vector{Float64} # State
    W::Matrix{Float64} # Weights
    β::Float64 # Gain needed for the activation
end

function ContinuousHopfieldNet(n::Integer, β::Float64=1.0)
    s = ones(n)
    W = zeros(n, n)
    return ContinuousHopfieldNet(s, W, β)
end

# Perform one asynchronous update on randomly selected neuron
function update!(net::ContinuousHopfieldNet)
    i = rand(1:length(net.s))
    net.s[i] = tanh(net.β * (net.W[i, :]' * net.s))
    # Note: W[i, :] = W[:, i] as long as the matrix is symmetric
    return
end

function Base.show(io::IO, net::ContinuousHopfieldNet)
    @printf io "A continuous Hopfield net with %d neurons\n" length(net.s)
end
