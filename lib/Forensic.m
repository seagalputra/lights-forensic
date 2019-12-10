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

% Last Modified by GUIDE v2.5 10-Dec-2019 09:51:55

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
% uiwait(handles.figure1);


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


% --- Executes on button press in btn_detail.
function btn_detail_Callback(hObject, eventdata, handles)
% hObject    handle to btn_detail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
% hObject    handle to btn_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
