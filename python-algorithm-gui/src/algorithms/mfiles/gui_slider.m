function GUI_slider
clc
clear

%// Create GUI controls
handles.figure = figure('Position',[100 100 500 500],'Units','Pixels');

handles.axes1 = axes('Units','Pixels','Position',[60,100,400,300]);

handles.Slider1 = uicontrol('Style','slider','Position',[60 20 400 50],'Min',0,'Max',1,'SliderStep',[.1 .1],'Callback',@SliderCallback);

handles.Edit1 = uicontrol('Style','Edit','Position',[250 450 100 20],'String','Update Me');
handles.Text1 = uicontrol('Style','Text','Position',[180 450 60 20],'String','Slider Value');

handles.xrange = 1:20; %// Use to generate dummy data to plot.

guidata(handles.figure,handles); %// Update the handles structure.

    function SliderCallback(~,~) %// This is the slider callback, executed when you release the it or press the arrows at each extremity.

        handles = guidata(gcf);

        SliderValue = get(handles.Slider1,'Value');
        set(handles.Edit1,'String',num2str(SliderValue));

        plot(handles.xrange,SliderValue*rand(1,20),'Parent',handles.axes1);
    end

end