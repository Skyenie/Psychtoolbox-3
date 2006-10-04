function SpriteDemo

% SpriteDemo animates a sprite across the screen.  The image
% follows the mouse, like a huge cursor.
% 
% There are many ways to create animations.  The simplest is to show a
% movie, computing all the frames in advance, as in MovieDemo.  Sprites may
% be a better approach when you want to show a relatively small object
% moving unpredictably.  Here we generate one offscreen window holding the
% sprite image and copy it to the screen for each frame of the animation,
% specifying the screen location by using the destination rect argument of
% Screen 'CopyWindow'.
% 
% See also MovieDemo.
% 
% Thanks to tj <thomasjerde@hotmail.com> for asking how. 
% web http://groups.yahoo.com/group/psychtoolbox/message/1101 ;
%
% 6/20/02 awi  Wrote it as TargetDemo.  
% 6/20/02 dgp  Cosmetic.  Renamed SpriteDemo.
% 8/25/06 rhh  Added noise to the sprite.  Expanded comments.


% ------ Parameters ------
spriteSize = 100; % The height and width of the sprite in pixels (the sprite is square)
numberOfSpriteFrames = 25; % The number of animation frames for our sprite

try

    % ------ Screen and Color Setup ------

    % Choose a screen
    screenNumber = 0;

    % Get colors
    backgroundColor = BlackIndex(screenNumber);
    foregroundColor = WhiteIndex(screenNumber);
    foregroundMinusBackground = abs(foregroundColor - backgroundColor);

    % Removes the blue screen flash and minimize extraneous warnings.
	Screen('Preference', 'VisualDebugLevel', 3);
    Screen('Preference', 'SuppressAllWarnings', 1);
    
    % Open a window and paint the background white
    window = Screen('OpenWindow', 0, foregroundColor);

    % Hide the mouse cursor.
    HideCursor;

    % ------ Animation Setup ------
    for i = 1 : numberOfSpriteFrames
        % Create the frames for the animated sprite.  Here the animation
        % consists of noise.        
        spriteFrame(i) = Screen('MakeTexture', window, backgroundColor + foregroundMinusBackground * rand(spriteSize));
    end

    % ------ Bookkeeping Variables ------
    
    spriteRect = [0 0 spriteSize spriteSize]; % The bounding box for our animated sprite
    spriteFrameIndex = 1; % Which frame of the animation should we show?
    buttons = 0; % When the user clicks the mouse, 'buttons' becomes nonzero.
    mX = 0; % The x-coordinate of the mouse cursor
    mY = 0; % The y-coordinate of the mouse cursor

    % Exit the demo as soon as the user presses a mouse button.
    while ~any(buttons)
        % We need to redraw the text or else it will disappear after a
        % subsequent call to Screen('Flip').
        Screen('DrawText', window, 'Move the mouse.  Click to exit', 0, 0, backgroundColor);
        
        % Get the location and click state of the mouse.
        previousX = mX;
        previousY = mY;
        [mX, mY, buttons] = GetMouse; 
        
        % Draw the sprite at the new location.
        Screen('DrawTexture', window, spriteFrame(spriteFrameIndex), spriteRect, CenterRectOnPoint(spriteRect, mX, mY));
        % Call Screen('Flip') to update the screen.  Note that calling
        % 'Flip' after we have both erased and redrawn the sprite prevents
        % the sprite from flickering.
        Screen('Flip', window);
        
        % Animate the sprite only when the mouse is moving.
        if (previousX ~= mX) | (previousY ~= mY)
            spriteFrameIndex = spriteFrameIndex + 1;
            if spriteFrameIndex > numberOfSpriteFrames
                spriteFrameIndex = 1;
            end
        end
    end

    ShowCursor; % Revive the mouse cursor.
    Screen('CloseAll');

catch
    
    % If there is an error in our try block, let's
    % return the user to the familiar MATLAB prompt.
    ShowCursor; 
    Screen('CloseAll');
    psychrethrow(psychlasterror);
    
end
