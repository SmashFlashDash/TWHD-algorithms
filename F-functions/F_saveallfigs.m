% Сохранить все фигуры
function F_saveallfigs(Folder)
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    for iFig = 1:length(FigList)
        FigHandle = FigList(iFig);
        FigName = FigHandle.Name;
        set(0, 'CurrentFigure', FigHandle);
        savefig(fullfile(Folder, [FigName '.fig']));
    end
end