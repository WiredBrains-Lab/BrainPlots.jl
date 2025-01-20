"""
    function brainscatter(brain,points;
        size=(1200,500),
        color=:red,
        markersize=2,
        alpha=0.2,
        azimuth=pi,
        elevation=0.
    )

Graph the mesh `brain` and draw spheres at `points` locations.

`points` can either be a Vector of coordinates or Pairs of (color,coordinate)
"""
function brainscatter(brain::MeshIO.Mesh,points;
        size=(1200,500),
        color=:red,
        markersize=2,
        alpha=0.2,
        azimuth=pi,
        elevation=0.
    )
    f = Figure(;size)
    ax = Axis3(f[1,1];azimuth,elevation,aspect=:data)
    mesh!(ax,brain)
    for p in points
        if p isa Pair
            color = p.first
            pp = p.second
        else
            color = color
            pp = p
        end
        meshscatter!(ax,pp;color,markersize,alpha)
    end
    return f
end

"""
    function brainmesh(
        brain::MeshIO.Mesh,
        points::Vector{Point3f};
        sd::Float64=15.,
        scale=200,   
    color_scale=range(colorant"blue",colorant"red",length=100),
        all_points=nothing,
        other_color=RGBf(0.05,0.05,0.35),
        size=(1200,500),
        azimuth=pi,
        elevation=0.
    )

Draw `brain` and create a continous map of color centered on `points` using the SD distance `sd` and scale of colors `color_scale`.

If `all_points` is given, only areas of the brain the are around the points `all_points` will get the low-end of the color scale. All other points in other parts of the brain will be colored `other_color`. This denotes areas where there is no data.
"""
function brainmesh(
        brain::MeshIO.Mesh,
        points::Vector{Point3f};
        sd::Float64=15.,
        scale=200,   
    color_scale=range(colorant"blue",colorant"red",length=100),
        all_points=nothing,
        other_color=RGBf(0.05,0.05,0.35),
        size=(1200,500),
        azimuth=pi,
        elevation=0.
    )
    brain_tree = KDTree(brain.position)

    if all_points==nothing
        cc = fill(1.,length(brain_tree.data))
    else
        cc = fill(0.,length(brain_tree.data))

        for p in all_points
            x = inrange(brain_tree,[p],sd*2)[1]
            cc[x] .= 1
        end
    end

    ww = pdf(Normal(0,sd),0:(3*sd))
    ww = 2 .* ww ./ ww[1]

    for p in points
        for (i,w) in enumerate(ww)
            x = inrange(brain_tree,[p],i)[1]
            for xx in x
                cc[xx]>0 && (cc[xx] += w)
            end
        end
    end
    
    color = map(cc) do i
        if i==0
            return other_color
        else
            return color_scale[min(max(1,round(Int,i)),length(color_scale))]
        end
    end

    
    f = Figure(;size)
    ax = Axis3(f[1,1];azimuth,elevation,aspect=:data)
    mesh!(ax,brain;color)
    return f
end 
