% Создание фигур
function F_change_ax_figs(nfigurs)
% nfigurs - кол-во фигур в строке
    global xd yd x y xreset yreset
    if x <= xd * (nfigurs-1)-1
        x = x + xd;
    else
        y = y - yd-100;
        x = xreset;
    end
    if y < yd
        y = yreset;
        xreset = xreset + 100;
    end
end