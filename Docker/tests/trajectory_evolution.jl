using DrWatson
@quickactivate "NonlinearDynamicsTextbook"
include(srcdir("colorscheme.jl"))

using InteractiveDynamics, DynamicalSystems, GLMakie
using OrdinaryDiffEq: Vern9

ds = Systems.henonheiles() #initialise le system de Henon

#CIs
u0s = (
    [0.0, -0.25, 0.42, 0.0], # chaotic
    [0.0, 0.1, 0.5, 0.0], # quasiperiodic
    [0.0, 0.30266571044921875, 0.4205654433900762, 0.0], # periodic
)

diffeq = (alg = Vern9(), dtmax = 0.05)
idxs = [1, 2, 4]

#creer une visualisation interactive de l'évolution du système dans le temps pour les 3 CIs
fig, obs, = interactive_evolution(
    ds, u0s; idxs, tail=2000, diffeq=diffeq, colors=COLORS[1:3]
)

# ds, u0s;
# tail = 1000, lims,

ax = content(fig[1,1])
ax.xlabel = "q₁"
ax.ylabel = "q₂"
ax.zlabel = "v₂"
# main.figure[AbstractPlotting.Axis][:names, :axisnames] = ("q₁", "q₂", "v₂")


# %%
record_interaction(fig, string(@__FILE__)[1:end-2]*"mp4"; total_time = 15)