function saveAllFigs(FolderName,FileNames)
%Function to save all open figures to specified folder
% filenames are indexed by figure number - 'fig_x.png'
% add functionality for exportfig for pdf and jpeg files 
% https://github.com/altmany/export_fig
% FileNames specified as cell

h =  findobj('type','figure');
    for i = 1:length(h)
        % saveas(figure(i),[FolderName,'\fig_',num2str(i),'.png'])
        if nargin == 1
            file_name = [FolderName,'\fig_',num2str(i)];
        else
            file_name = [FolderName,'\',char(FileNames(i))];
        end
        set(figure(i), 'Color', 'w');
        % export_fig (file_name, '-pdf', '-jpeg')
        export_fig (file_name, '-jpeg')
    end

end