function varargout = cor(varargin)
% COR MATLAB code for cor.fig
%      COR, by itself, creates a new COR or raises the existing
%      singleton*.
%
%      H = COR returns the handle to a new COR or the handle to
%      the existing singleton*.
%
%      COR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COR.M with the given input arguments.
%
%      COR('Property','Value',...) creates a new COR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cor

% Last Modified by GUIDE v2.5 17-May-2016 15:21:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cor_OpeningFcn, ...
                   'gui_OutputFcn',  @cor_OutputFcn, ...
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


% --- Executes just before cor is made visible.
function cor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cor (see VARARGIN)

% Choose default command line output for cor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cor wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global c A M
c=0;
load('AM.mat','A','M');

% --- Outputs from this function are returned to the command line.
function varargout = cor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A M

Fs=8000;
recorder = audiorecorder(Fs,16,1);
disp('Start speaking.');
recordblocking(recorder, 1.5);
disp('End of recording');
B=getaudiodata(recorder);
sound(B,Fs)

B=B/abs(max(B));


% corrA=xcorr(A,A);
% corrM=xcorr(M,M);
% corrAB=xcorr(A,B);
% corrMB=xcorr(M,B);

% corrAord=sort(corrA);
% corrABord=sort(corrAB);
% corrMord=sort(corrM);
% corrMBord=sort(corrMB);
% 
% v=50;
% vi=1500+v;
% L=length(corrAord);
% L1=length(corrABord);
% mA=(corrAord(L-v)-corrAord(L-vi))/(vi-v);
% mAB=(corrABord(L1-v)-corrABord(L1-vi))/(vi-v);
% pncAB=(mAB/mA)*100
% 
% L=length(corrMord);
% L1=length(corrMBord);
% mM=(corrMord(L-v)-corrMord(L-vi))/(vi-v);
% mMB=(corrMBord(L1-v)-corrMBord(L1-vi))/(vi-v);
% pncMB=(mMB/mM)*100

maxlagsA = numel(A)*0.5;
maxlagsM = numel(M)*0.5;
[corrA,lagA]=xcorr(A,A,maxlagsA);
[corrM,lagM]=xcorr(M,M,maxlagsM);
[corrAB,lagAB]=xcorr(A,B,maxlagsA);
[corrMB,lagMB]=xcorr(M,B,maxlagsM);

[~,dfA] = findpeaks(corrA,'MinPeakDistance',5*2*24*10);
[~,dfM] = findpeaks(corrM,'MinPeakDistance',5*2*24*10);
[~,dfAB] = findpeaks(corrAB,'MinPeakDistance',5*2*24*10);
[~,dfMB] = findpeaks(corrMB,'MinPeakDistance',5*2*24*10);

P100A=corrA(dfA(3))-corrA(dfA(4));
P100M=corrM(dfM(3))-corrM(dfM(4));
pAB=abs(corrAB(dfAB(3))-corrAB(dfAB(4)))
pMB=abs(corrMB(dfMB(3))-corrMB(dfMB(4)))
pAB=(pAB/P100A)*100
pMB=(pMB/P100M)*100
if pMB>=15 || pAB>=15
    if pMB>pAB
    axes(handles.axes1)
    matlabImage = imread('elcapo.jpg');
    image(matlabImage)
    axis off
    axis image
    else
    axes(handles.axes1)
    matlabImage = imread('demilindo.jpg');
    image(matlabImage)
    axis off
    axis image
    end
else
axes(handles.axes1)
matlabImage = imread('404.jpg');
image(matlabImage)
axis off
axis image
end
