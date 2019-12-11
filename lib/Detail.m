function varargout = Detail(varargin)
% DETAIL MATLAB code for Detail.fig
%      DETAIL, by itself, creates a new DETAIL or raises the existing
%      singleton*.
%
%      H = DETAIL returns the handle to a new DETAIL or the handle to
%      the existing singleton*.
%
%      DETAIL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DETAIL.M with the given input arguments.
%
%      DETAIL('Property','Value',...) creates a new DETAIL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Detail_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Detail_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Detail

% Last Modified by GUIDE v2.5 10-Dec-2019 18:31:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Detail_OpeningFcn, ...
                   'gui_OutputFcn',  @Detail_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Detail is made visible.
function Detail_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Detail (see VARARGIN)

% Choose default command line output for Detail
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Detail wait for user response (see UIRESUME)
% uiwait(handles.detail);

h = findobj('Tag', 'forensic');

if ~isempty(h)
    forensic_data = guidata(h);
    
    axes(handles.fig_segmentation);
    imshow(forensic_data.resultMask);
    
    % plot surface normal for first object
    axes(handles.fig_object1);
    imshow(forensic_data.resultGray{1});
    hold on;
    plot([forensic_data.listVertices{1}(:,1) forensic_data.listVertices{1}(:,1)+10*forensic_data.surfaceNormals{1}(:,1)]', ...
        [forensic_data.listVertices{1}(:,2) forensic_data.listVertices{1}(:,2)+10*forensic_data.surfaceNormals{1}(:,2)]');
    
    % plot surface normal for second object
    axes(handles.fig_object2);
    imshow(forensic_data.resultGray{2});
    hold on;
    plot([forensic_data.listVertices{2}(:,1) forensic_data.listVertices{2}(:,1)+10*forensic_data.surfaceNormals{2}(:,1)]', ...
        [forensic_data.listVertices{2}(:,2) forensic_data.listVertices{2}(:,2)+10*forensic_data.surfaceNormals{2}(:,2)]');
    
    % plot lambertian sphere
    firstCoeff = forensic_data.listLights{1};
    firstCoeff(6:9,:) = 0;
    axes(handles.fig_light1);
    firstShading = plotLitSphere2(firstCoeff, 4, 1);
    
    secondCoeff = forensic_data.listLights{2};
    secondCoeff(6:9,:) = 0;
    axes(handles.fig_light2);
    secondShading = plotLitSphere2(secondCoeff, 4, 1);
end

% --- Outputs from this function are returned to the command line.
function varargout = Detail_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
