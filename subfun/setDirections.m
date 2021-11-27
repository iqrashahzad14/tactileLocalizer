function cfg = setDirections(cfg)

    [MOTION_DIRECTIONS, STATIC_DIRECTIONS] = getDirectionBaseVectors(cfg);

    [NB_BLOCKS, NB_REPETITIONS, NB_EVENTS_PER_BLOCK] = getInput(cfg);

    [~, STATIC_INDEX, MOTION_INDEX] = assignConditions(cfg);

    if mod(NB_EVENTS_PER_BLOCK, length(MOTION_DIRECTIONS)) ~= 0
        error('Number of events/block not a multiple of number of motion/static direction');
    end

    % initialize
    directions = zeros(NB_BLOCKS, NB_EVENTS_PER_BLOCK);

    % Create a vector for the static condition
    NB_REPEATS_BASE_VECTOR = NB_EVENTS_PER_BLOCK / length(STATIC_DIRECTIONS);

    static_directions = repmat( ...
                               STATIC_DIRECTIONS, ...
                               1, NB_REPEATS_BASE_VECTOR);

    for iMotionBlock = 1:NB_REPETITIONS

        % Set motion direction and static order
        directions(MOTION_INDEX(iMotionBlock), :) = ...
            repeatShuffleConditions(MOTION_DIRECTIONS, NB_REPEATS_BASE_VECTOR);
        directions(STATIC_INDEX(iMotionBlock), :) = static_directions;

    end

    cfg.design.directions = directions;

end



