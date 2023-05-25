function [flag] = dialogueQuestionBox(quest)
%UFunction to generate dialogue box

answer = questdlg(quest,'','Yes','No','Yes');
if strcmp(answer,'Yes')
    close all
    flag = false;
else
    flag = true;
end
end