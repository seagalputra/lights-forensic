function varargout = Forensic(varargin)
% FORENSIC MATLAB code for Forensic.fig
%      FORENSIC, by itself, creates a new FORENSIC or raises the existing
%      singleton*.
%
%      H = FORENSIC returns the handle to a new FORENSIC or the handle to
%      the existing singleton*.
%
%      FORENSIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORENSIC.M with the given input arguments.
%
%      FORENSIC('Property','Value',...) creates a new FORENSIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Forensic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Forensic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Forensic

% Last Modified by GUIDE v2.5 10-Dec-2019 18:30:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Forensic_OpeningFcn, ...
                   'gui_OutputFcn',  @Forensic_OutputFcn, ...
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


% --- Executes just before Forensic is made visible.
function Forensic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Forensic (see VARARGIN)

% Choose default command line output for Forensic
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Forensic wait for user response (see UIRESUME)
% uiwait(handles.forensic);


% --- Outputs from this function are returned to the command line.
function varargout = Forensic_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popup_label.
function popup_label_Callback(hObject, eventdata, handles)
% hObject    handle to popup_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_label contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_label
global label;
contents = cellstr(get(hObject, 'String'));
choice = contents{get(hObject, 'Value')};
if (strcmp(choice, 'Tidak terindikasi manipulasi'))
    label = 1;
elseif (strcmp(choice, 'Terindikasi manipulasi'))
    label = 0;
else
    label = NaN;
end

% set label into static text
set(handles.text_actual, 'String', choice);

% --- Executes during object creation, after setting all properties.
function popup_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in btn_deteksi.
function btn_deteksi_Callback(hObject, eventdata, handles)
% hObject    handle to btn_deteksi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
global label;
global mask;
global gray;
global params;
global listNormals;
global listVertices;
global lights;

% resize image into half
imgResize = imresize(image, 0.5);
% segment image using meanshift
disp('Segmenting image...');
[obj, gray, mask, params] = imsegment(imgResize, ...
    'segType', 'meanshift', ...
    'SpatialBandWidth', 3, ...
    'RangeBandWidth', 6.5, ...
    'gamma', 0.32, ...
    'numberToExtract', 2, ...
    'sizeThreshold', 500);

% calculate complex lighting environment
lights = {};
listDegree = [];
listNormals = {};
listVertices = {};
disp('Estimating light direction..');
for i = 1:size(obj,2)
    [light, degree, normals, vertices] = lightDirection(obj{i}, gray{i}, ...
                'modelType', 'complex');
    lights{end+1} = light;
    listDegree = [listDegree; degree];
    
    listNormals{end+1} = normals;
    listVertices{end+1} = vertices;
end
% compute correlation between several lighting condition
possibleLights = nchoosek(lights,2);
for numLight = 1:size(possibleLights,1)
    corrLight(numLight,:) = getCorrelation(possibleLights{numLight,1}, possibleLights{numLight,2});
end
% compute different between principal light direction
possibleDegree = nchoosek(listDegree,2);
diffLight = abs(possibleDegree(:,2) - possibleDegree(:,1));

% by using membership function, classify image into appropriate label
degreeCorrelation(1) = sigmoidLeft(corrLight, 0.15, 0.23, 0.3);
degreeCorrelation(2) = sigmoidRight(corrLight, 0.24, 0.4, 0.8);
degreeTheta(1) = sigmoidLeft(diffLight, 45, 57, 92);
degreeTheta(2) = sigmoidRight(diffLight, 81, 105, 135);
[predicted, degreeForgery, degreeAuthentic] = rule(degreeCorrelation, degreeTheta);

% setup the gui
set(handles.text_theta, 'String', num2str(diffLight));
set(handles.text_correlation, 'String', num2str(corrLight));
set(handles.text_authentic, 'String', num2str(degreeAuthentic));
set(handles.text_forgery, 'String', num2str(degreeForgery));

if (predicted == 1)
    set(handles.text_predict, 'String', 'Tidak terindikasi manipulasi');
elseif (predicted == 0)
    set(handles.text_predict, 'String', 'Terindikasi manipulasi');
end

if (predicted == 1 & label == 1)
    set(handles.text_status, 'String', 'True Positive');
elseif (predicted == 1 & label == 0)
    set(handles.text_status, 'String', 'False Positive');
elseif (predicted == 0 & label == 0)
    set(handles.text_status, 'String', 'True Negative');
elseif (predicted == 0 & label == 1)
    set(handles.text_status, 'String', 'False Negative');
end

% --- Executes on button press in btn_detail.
function btn_detail_Callback(hObject, eventdata, handles)
% hObject    handle to btn_detail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mask;
global gray;
global params;
global listNormals;
global listVertices;
global lights;

handles.resultMask = mask;
handles.resultGray = gray;
handles.parameter = params;
handles.surfaceNormals = listNormals;
handles.listVertices = listVertices;
handles.listLights = lights;

guidata(hObject, handles);

Detail

% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
[filename, path] = uigetfile({'*.png;*.jpg;*.tif','Image Files'});
image = imread(fullfile(path,filename));

% showing image in figure
axes(handles.fig_image);
imshow(image);

% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialText = '-';
cla(handles.fig_image);
set(handles.text_actual, 'String', initialText);
set(handles.text_predict, 'String', initialText);
set(handles.text_status, 'String', initialText);
set(handles.popup_label, 'Value', 1);
