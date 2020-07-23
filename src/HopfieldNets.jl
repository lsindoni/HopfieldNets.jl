module HopfieldNets
    export HopfieldNet, DiscreteHopfieldNet, ContinuousHopfieldNet
    export update!, energy, settle!, train!, associate!, storkeytrain!

    import Printf: @printf

    include("generic.jl")
    include("discrete.jl")
    include("continuous.jl")
end
