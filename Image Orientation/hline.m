% Example call of the HLINE-function
% ----------------------------------
% function test                    
% %        ====
% l = [-1 1 50]';                             % Line equation in implicit form
% f = imread('image.jpg');                                      % Read image f
% figure, imshow(f), hold on                        % Show image in new window 
% hline(l);                                       % Draw red line l in image f

function hline(l)
%        ========
if abs(l(1)) < abs(l(2))
    xlim = get(get(gcf, 'CurrentAxes'), 'Xlim');      
    x1 = cross(l, [1 0 0]');
    x2 = cross(l, [-1/xlim(2) 0 1]');
else
    ylim = get(get(gcf, 'CurrentAxes'), 'Ylim');      
    x1 = cross(l, [0 1 0]');
    x2 = cross(l, [0 -1/ylim(2) 1]');
end
x1 = x1 / x1(3);
x2 = x2 / x2(3);
line([x1(1) x2(1)], [x1(2) x2(2)], 'color', 'red');